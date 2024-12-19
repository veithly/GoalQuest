// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ITask } from "../interfaces/ITask.sol";

library TaskStorage {
    bytes32 constant STORAGE_POSITION = keccak256("goalquest.storage.task");

    struct Layout {
        // Task ID counter
        uint32 taskCounter;
        // Task ID => Task
        mapping(uint32 => ITask.Task) tasks;
        // User address => Task IDs
        mapping(address => uint32[]) userTasks;
        // Task ID => Participant addresses
        mapping(uint32 => address[]) taskParticipants;
        // Task ID => Participant address => bool
        mapping(uint32 => mapping(address => bool)) isParticipant;
        // Task ID => Total staked amount
        mapping(uint32 => uint96) totalStaked;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            l.slot := position
        }
    }
}