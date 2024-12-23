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
        IDiamond.FacetCut[] memory cut = new IDiamond.FacetCut[](2);

        // 3. 设置原有的 function selectors
        bytes4[] memory existingSelectors = new bytes4[](6);
        existingSelectors[0] = TaskFacet.createTask.selector;
        existingSelectors[1] = TaskFacet.joinTask.selector;
        existingSelectors[2] = TaskFacet.joinTaskWithToken.selector;
        existingSelectors[3] = TaskFacet.getTask.selector;
        existingSelectors[4] = TaskFacet.getUserTasks.selector;
        existingSelectors[5] = TaskFacet.isParticipant.selector;

        // 4. 替换现有功能
        cut[0] = IDiamond.FacetCut({
            facetAddress: address(newTaskFacet),
            action: IDiamond.FacetCutAction.Replace,
            functionSelectors: existingSelectors
        });

        vm.sleep(10 seconds);

        // 5. 设置新的 function selector
        bytes4[] memory newSelectors = new bytes4[](1);
        newSelectors[0] = TaskFacet.getAllTasks.selector;

        // 6. 添加新功能
        cut[1] = IDiamond.FacetCut({
            facetAddress: address(newTaskFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: newSelectors
        });

        vm.sleep(10 seconds);

        // 7. 执行 diamondCut
        IDiamond(diamondAddress).diamondCut(cut, address(0), "");
        console2.log("TaskFacet updated successfully with new getAllTasks function");

        vm.stopBroadcast();
    }
}