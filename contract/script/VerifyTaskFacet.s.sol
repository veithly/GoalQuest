// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {ITask} from "../src/interfaces/ITask.sol";

contract VerifyTaskFacetScript is Script {
    function verifyFunctions() public view {
        address diamondAddress = vm.envAddress("DIAMOND_ADDRESS");

        // 尝试调用 getAllTasks
        try ITask(diamondAddress).getAllTasks() returns (ITask.Task[] memory tasks) {
            console2.log("getAllTasks function exists and returned", tasks.length, "tasks");

            // 打印第一个任务的信息（如果有）
            if (tasks.length > 0) {
                console2.log("First task id:", tasks[0].id);
                console2.log("First task creator:", tasks[0].creator);
            }
        } catch {
            console2.log("getAllTasks function call failed");
        }
    }
}