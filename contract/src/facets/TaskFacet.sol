// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import { LibTask } from "../libraries/LibTask.sol";
import { ITask } from "../interfaces/ITask.sol";

contract TaskFacet is ITask {
    function createTask(
        uint32 startTime,
        uint32 endTime,
        uint96 stakingAmount,
        uint16 participantsLimit,
        uint8 taskType,
        address stakingToken,
        string calldata configHash
    ) external override returns (uint32) {
        return LibTask.createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            stakingToken,
            configHash
        );
    }

    function joinTask(uint32 taskId) external payable override {
        LibTask.joinTask(taskId);
    }

    function joinTaskWithToken(uint32 taskId) external override {
        LibTask.joinTaskWithToken(taskId);
    }

    function getTask(uint32 taskId) external view override returns (Task memory) {
        return LibTask.getTask(taskId);
    }

    function getUserTasks(address user) external view override returns (uint32[] memory) {
        return LibTask.getUserTasks(user);
    }

    function isParticipant(uint32 taskId, address user) external view override returns (bool) {
        return LibTask.isTaskParticipant(taskId, user);
    }
}