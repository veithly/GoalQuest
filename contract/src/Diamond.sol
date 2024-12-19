// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibDiamond } from "./libraries/LibDiamond.sol";
import { IDiamond } from "./interfaces/IDiamond.sol";
import { DiamondStorage } from "./storage/DiamondStorage.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Diamond is IDiamond, UUPSUpgradeable, OwnableUpgradeable {
    constructor(address _contractOwner, address _diamondCutFacet) {
        LibDiamond.setContractOwner(_contractOwner);

        IDiamond.FacetCut[] memory cut = new IDiamond.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = IDiamond.diamondCut.selector;

        cut[0] = IDiamond.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });

        LibDiamond.diamondCut(cut, address(0), "");

        _initialize(_contractOwner);
    }

    function _initialize(address initialOwner) internal initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    // 实现 IDiamond 接口
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.diamondCut(_diamondCut, _init, _calldata);
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        DiamondStorage.Layout storage ds = DiamondStorage.layout();
        address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}

    function _authorizeUpgrade(address) internal override onlyOwner {}
}