// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ICheckIn } from "../interfaces/ICheckIn.sol";
import { ITask } from "../interfaces/ITask.sol";
import { LibTask } from "./LibTask.sol";
import { CheckInStorage } from "../storage/CheckInStorage.sol";
import { TaskStorage } from "../storage/TaskStorage.sol";

library LibCheckIn {
    function submitCheckIn(
        uint32 taskId,
        string memory proofHash
    ) internal returns (uint32) {
        CheckInStorage.Layout storage cs = CheckInStorage.layout();

        require(LibTask.isTaskParticipant(taskId, msg.sender), "Not a participant of this task");
        require(bytes(proofHash).length > 0, "Proof hash cannot be empty");

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(task.flags & 1 == 1, "Task is not active");
        require(uint32(block.timestamp) >= task.startTime, "Task has not started");
        require(uint32(block.timestamp) <= task.endTime, "Task has ended");

        // Check if user has already checked in today
        uint32 today = uint32(block.timestamp / 1 days);
        require(cs.dailyCheckIns[taskId][msg.sender][today] == 0, "Already checked in today");

        uint32 checkInId = ++cs.checkInCounter;

        cs.checkIns[checkInId] = ICheckIn.CheckIn({
            id: checkInId,
            taskId: taskId,
            timestamp: uint32(block.timestamp),
            status: 0, // PENDING
            aiScore: 0,
            participant: msg.sender,
            proofHash: proofHash
        });

        cs.dailyCheckIns[taskId][msg.sender][today] = checkInId;
        cs.userCheckInCounts[taskId][msg.sender]++;

        emit ICheckIn.CheckInSubmitted(checkInId, taskId, msg.sender, proofHash);

        return checkInId;
    }

    function updateAIReview(
        uint32 checkInId,
        uint8 status,
        uint8 aiScore
    ) internal {
        CheckInStorage.Layout storage cs = CheckInStorage.layout();
        ICheckIn.CheckIn storage checkIn = cs.checkIns[checkInId];

        require(checkIn.id != 0, "CheckIn does not exist");
        require(checkIn.status == 0, "CheckIn is not pending"); // PENDING
        require(aiScore <= 100, "AI score must be between 0 and 100");
        require(status <= 3, "Invalid status"); // Max status value is REVIEWING (3)

        checkIn.status = status;
        checkIn.aiScore = aiScore;

        emit ICheckIn.CheckInReviewed(
            checkInId,
            checkIn.taskId,
            checkIn.participant,
            status,
            aiScore
        );
    }

    function getCheckIn(uint32 checkInId) internal view returns (ICheckIn.CheckIn storage) {
        CheckInStorage.Layout storage cs = CheckInStorage.layout();
        require(cs.checkIns[checkInId].id != 0, "CheckIn does not exist");
        return cs.checkIns[checkInId];
    }

    function getUserDailyCheckIn(
        uint32 taskId,
        address user,
        uint32 timestamp
    ) internal view returns (ICheckIn.CheckIn storage) {
        CheckInStorage.Layout storage cs = CheckInStorage.layout();
        uint32 day = uint32(timestamp / 1 days);
        uint32 checkInId = cs.dailyCheckIns[taskId][user][day];
        require(checkInId != 0, "No check-in found for this day");
        return cs.checkIns[checkInId];
    }

    function getUserCheckInCount(uint32 taskId, address user) internal view returns (uint32) {
        return CheckInStorage.layout().userCheckInCounts[taskId][user];
    }
}