// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import { LibCheckIn } from "../libraries/LibCheckIn.sol";
import { ICheckIn } from "../interfaces/ICheckIn.sol";

contract CheckInFacet is ICheckIn {
    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }

    function submitCheckIn(
        uint32 taskId,
        string calldata proofHash
    ) external override returns (uint32) {
        return LibCheckIn.submitCheckIn(taskId, proofHash);
    }

    function updateAIReview(
        uint32 checkInId,
        uint8 status,
        uint8 aiScore
    ) external override onlyOwner {
        LibCheckIn.updateAIReview(checkInId, status, aiScore);
    }

    function requestPeerReview(uint32 checkInId) external override {
        ICheckIn.CheckIn storage checkIn = LibCheckIn.getCheckIn(checkInId);
        require(checkIn.participant == msg.sender, "Not the check-in owner");
        require(checkIn.status == 2, "Check-in not rejected"); // REJECTED

        // Update status to REVIEWING
        LibCheckIn.updateAIReview(checkInId, 3, checkIn.aiScore);

        emit PeerReviewRequested(checkInId, checkIn.taskId, msg.sender);
    }

    function getCheckIn(uint32 checkInId) external view override returns (CheckIn memory) {
        return LibCheckIn.getCheckIn(checkInId);
    }

    function getUserDailyCheckIn(
        uint32 taskId,
        address user,
        uint32 timestamp
    ) external view override returns (CheckIn memory) {
        return LibCheckIn.getUserDailyCheckIn(taskId, user, timestamp);
    }
}