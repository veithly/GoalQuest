// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IPeerReview } from "../interfaces/IPeerReview.sol";
import { ITask } from "../interfaces/ITask.sol";
import { ICheckIn } from "../interfaces/ICheckIn.sol";
import { LibTask } from "./LibTask.sol";
import { LibCheckIn } from "./LibCheckIn.sol";
import { PeerReviewStorage } from "../storage/PeerReviewStorage.sol";
import { CheckInStorage } from "../storage/CheckInStorage.sol";
import { TaskStorage } from "../storage/TaskStorage.sol";

library LibPeerReview {
    uint32 constant REVIEW_DEADLINE = 1 days;
    uint8 constant REQUIRED_REVIEWERS = 3;

    function assignReviewers(uint32 checkInId) internal returns (address[] memory) {
        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();

        // Get check-in details
        CheckInStorage.Layout storage cs = CheckInStorage.layout();
        ICheckIn.CheckIn storage checkIn = cs.checkIns[checkInId];

        require(checkIn.id != 0, "CheckIn does not exist");
        require(checkIn.status == 3, "CheckIn is not in reviewing status"); // REVIEWING

        // Get task participants
        address[] memory participants = LibTask.getTaskParticipants(checkIn.taskId);
        require(participants.length >= REQUIRED_REVIEWERS + 1, "Not enough participants for peer review");

        // Select random reviewers
        address[] memory reviewers = new address[](REQUIRED_REVIEWERS);
        uint256 selectedCount = 0;
        uint256 nonce = 0;

        while (selectedCount < REQUIRED_REVIEWERS) {
            uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, nonce))) % participants.length;
            address potentialReviewer = participants[randomIndex];

            // Skip if the potential reviewer is the check-in participant or already selected
            if (potentialReviewer != checkIn.participant && !isAlreadySelected(reviewers, potentialReviewer)) {
                reviewers[selectedCount] = potentialReviewer;
                selectedCount++;
            }
            nonce++;
        }

        // Create review session
        ps.reviewSessions[checkInId] = IPeerReview.ReviewSession({
            checkInId: checkInId,
            reviewers: reviewers,
            approvalCount: 0,
            rejectionCount: 0,
            isComplete: false,
            deadline: uint32(block.timestamp + REVIEW_DEADLINE)
        });

        // Emit events for each reviewer
        for (uint256 i = 0; i < reviewers.length; i++) {
            emit IPeerReview.ReviewerAssigned(checkInId, reviewers[i]);
        }

        return reviewers;
    }

    function submitReview(
        uint32 checkInId,
        bool approved,
        string memory proofHash
    ) internal {
        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();
        IPeerReview.ReviewSession storage session = ps.reviewSessions[checkInId];

        require(session.checkInId != 0, "Review session does not exist");
        require(!session.isComplete, "Review session is complete");
        require(block.timestamp <= session.deadline, "Review deadline has passed");
        require(isReviewer(checkInId, msg.sender), "Not assigned as reviewer");
        require(ps.reviews[checkInId][msg.sender].timestamp == 0, "Already submitted review");

        // Record the review
        ps.reviews[checkInId][msg.sender] = IPeerReview.Review({
            checkInId: checkInId,
            timestamp: uint32(block.timestamp),
            reviewer: msg.sender,
            approved: approved,
            proofHash: proofHash
        });

        // Update approval/rejection counts
        if (approved) {
            session.approvalCount++;
        } else {
            session.rejectionCount++;
        }

        // Increment reviewer's total reviews
        ps.reviewsCompleted[msg.sender]++;

        emit IPeerReview.ReviewSubmitted(checkInId, msg.sender, approved, proofHash);

        // Check if review session is complete
        if (session.approvalCount + session.rejectionCount == REQUIRED_REVIEWERS) {
            session.isComplete = true;

            // Update check-in status based on majority vote
            CheckInStorage.Layout storage cs = CheckInStorage.layout();
            ICheckIn.CheckIn storage checkIn = cs.checkIns[checkInId];

            bool finalApproval = session.approvalCount > session.rejectionCount;
            checkIn.status = finalApproval ? 1 : 2; // APPROVED : REJECTED

            emit IPeerReview.ReviewCompleted(checkInId, finalApproval);
        }
    }

    function isReviewer(uint32 checkInId, address user) internal view returns (bool) {
        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();
        address[] memory reviewers = ps.reviewSessions[checkInId].reviewers;

        for (uint256 i = 0; i < reviewers.length; i++) {
            if (reviewers[i] == user) {
                return true;
            }
        }
        return false;
    }

    function getReviewSession(uint32 checkInId) internal view returns (IPeerReview.ReviewSession storage) {
        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();
        require(ps.reviewSessions[checkInId].checkInId != 0, "Review session does not exist");
        return ps.reviewSessions[checkInId];
    }

    function getReview(uint32 checkInId, address reviewer) internal view returns (IPeerReview.Review storage) {
        return PeerReviewStorage.layout().reviews[checkInId][reviewer];
    }

    function isAlreadySelected(address[] memory reviewers, address reviewer) private pure returns (bool) {
        for (uint256 i = 0; i < reviewers.length; i++) {
            if (reviewers[i] == reviewer) {
                return true;
            }
        }
        return false;
    }
}