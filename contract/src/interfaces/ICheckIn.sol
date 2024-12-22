// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICheckIn {
    struct CheckIn {
        uint32 id;          // 支持超过 40 亿个打卡记录
        uint32 taskId;      // 对应的任务 ID
        uint32 timestamp;   // 打卡时间
        uint8 status;       // 打卡状态
        uint8 aiScore;      // AI 评分 (0-100)
        address participant; // 参与者地址
        string proofHash;   // IPFS hash，存储打卡内容、媒体文件等证明材料
    }

    // 使用 uint8 替代 enum，节省 gas
    // 0: PENDING    - 等待 AI 审核
    // 1: APPROVED   - 已通过
    // 2: REJECTED   - 已拒绝
    // 3: REVIEWING  - 人工复审中

    event CheckInSubmitted(
        uint32 indexed checkInId,
        uint32 indexed taskId,
        address indexed participant,
        string proofHash
    );

    event CheckInReviewed(
        uint32 indexed checkInId,
        uint32 indexed taskId,
        address indexed participant,
        uint8 status,
        uint8 aiScore
    );

    event PeerReviewRequested(
        uint32 indexed checkInId,
        uint32 indexed taskId,
        address indexed participant
    );

    function submitCheckIn(
        uint32 taskId,
        string calldata proofHash
    ) external returns (uint32);

    function updateAIReview(
        uint32 checkInId,
        uint8 status,
        uint8 aiScore
    ) external;

    function requestPeerReview(uint32 checkInId) external;

    function getCheckIn(uint32 checkInId) external view returns (CheckIn memory);

    function getUserDailyCheckIn(
        uint32 taskId,
        address user,
        uint32 timestamp
    ) external view returns (CheckIn memory);

    function getCheckInsByTask(uint32 taskId) external view returns (CheckIn[] memory);
}