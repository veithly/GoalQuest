// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IPeerReview {
    struct Review {
        uint32 checkInId;
        uint32 timestamp;
        address reviewer;
        bool approved;
        string proofHash;
    }

    struct ReviewSession {
        uint32 checkInId;
        uint32 deadline;
        uint8 approvalCount;
        uint8 rejectionCount;
        bool isComplete;
        address[] reviewers;
    }

    event ReviewerAssigned(
        uint32 indexed checkInId,
        address indexed reviewer
    );

    event ReviewSubmitted(
        uint32 indexed checkInId,
        address indexed reviewer,
        bool approved,
        string proofHash
    );

    event ReviewCompleted(
        uint32 indexed checkInId,
        bool approved
    );

    function assignReviewers(uint32 checkInId) external returns (address[] memory);

    function submitReview(
        uint32 checkInId,
        bool approved,
        string calldata proofHash
    ) external;

    function getReviewSession(uint32 checkInId) external view returns (ReviewSession memory);

    function getReview(
        uint32 checkInId,
        address reviewer
    ) external view returns (Review memory);

    function isReviewer(
        uint32 checkInId,
        address user
    ) external view returns (bool);
}