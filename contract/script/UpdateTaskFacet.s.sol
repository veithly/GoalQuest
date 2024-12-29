// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {IDiamond} from "../src/interfaces/IDiamond.sol";
import {TaskFacet} from "../src/facets/TaskFacet.sol";

contract UpdateFacetScript is Script {
    function updateTaskFacet() public {
        address diamondAddress = vm.envAddress("DIAMOND_ADDRESS");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. 部署新的 TaskFacet
        TaskFacet newTaskFacet = new TaskFacet();
        console2.log("New TaskFacet deployed at:", address(newTaskFacet));

        vm.sleep(10 seconds);

        // 2. 准备 diamondCut 数据
        IDiamond.FacetCut[] memory cut = new IDiamond.FacetCut[](1);

        // 3. 设置所有 function selectors
        bytes4[] memory selectors = new bytes4[](6);
        selectors[0] = TaskFacet.createTask.selector;
        selectors[1] = TaskFacet.joinTask.selector;
        selectors[2] = TaskFacet.getTask.selector;
        selectors[3] = TaskFacet.getUserTasks.selector;
        selectors[4] = TaskFacet.isParticipant.selector;
        selectors[5] = TaskFacet.getAllTasks.selector;

        // 4. 替换所有功能
        cut[0] = IDiamond.FacetCut({
            facetAddress: address(newTaskFacet),
            action: IDiamond.FacetCutAction.Replace,
            functionSelectors: selectors
        });

        vm.sleep(10 seconds);

        // 5. 执行 diamondCut
        IDiamond(diamondAddress).diamondCut(cut, address(0), "");
        console2.log("TaskFacet updated successfully with new implementation");

        vm.stopBroadcast();
    }
}