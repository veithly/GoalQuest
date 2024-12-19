// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IReward {
    struct RewardPool {
        uint32 taskId;           // 任务 ID
        uint96 totalAmount;      // 总奖励金额
        uint96 remainingAmount;  // 剩余奖励金额
        uint96 reviewerRewardAmount; // 评审者奖励金额
        address rewardToken;     // 奖励代币地址，address(0) 表示原生代币
        mapping(address => uint96) claimedAmounts; // 已领取金额
    }

    // 使用 uint8 替代 enum，节省 gas
    // 0: COMPLETION - 任务完成奖励
    // 1: REVIEW     - 评审奖励
    // 2: BONUS      - 额外奖励

    event RewardClaimed(
        uint32 indexed taskId,
        address indexed participant,
        uint96 amount,
        uint8 rewardType,
        address rewardToken
    );

    event RewardPoolCreated(
        uint32 indexed taskId,
        uint96 totalAmount,
        uint96 reviewerRewardAmount,
        address rewardToken
    );

    function createRewardPool(
        uint32 taskId,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) external payable;

    function createRewardPoolWithToken(
        uint32 taskId,
        uint96 totalAmount,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) external;

    function claimReward(uint32 taskId) external returns (uint96);

    function claimReviewerReward(uint32 taskId) external returns (uint96);

    function getClaimableAmount(
        uint32 taskId,
        address participant
    ) external view returns (uint96);

    function getReviewerRewardAmount(
        uint32 taskId,
        address reviewer
    ) external view returns (uint96);
}