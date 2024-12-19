// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IReward } from "../interfaces/IReward.sol";
import { ITask } from "../interfaces/ITask.sol";
import { LibTask } from "./LibTask.sol";
import { LibCheckIn } from "./LibCheckIn.sol";
import { LibPeerReview } from "./LibPeerReview.sol";
import { RewardStorage } from "../storage/RewardStorage.sol";
import { TaskStorage } from "../storage/TaskStorage.sol";
import { PeerReviewStorage } from "../storage/PeerReviewStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

library LibReward {
    using SafeERC20 for IERC20;

    function createRewardPool(
        uint32 taskId,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) internal {
        RewardStorage.Layout storage rs = RewardStorage.layout();

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(task.id != 0, "Task does not exist");
        require(rewardToken == address(0), "Use createRewardPoolWithToken for ERC20");
        require(msg.value > 0, "Reward amount must be greater than 0");
        require(rs.rewardPools[taskId].totalAmount == 0, "Reward pool already exists");

        rs.rewardPools[taskId].taskId = taskId;
        rs.rewardPools[taskId].totalAmount = uint96(msg.value);
        rs.rewardPools[taskId].remainingAmount = uint96(msg.value);
        rs.rewardPools[taskId].reviewerRewardAmount = reviewerRewardAmount;
        rs.rewardPools[taskId].rewardToken = rewardToken;

        emit IReward.RewardPoolCreated(taskId, uint96(msg.value), reviewerRewardAmount, rewardToken);
    }

    function createRewardPoolWithToken(
        uint32 taskId,
        uint96 totalAmount,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) internal {
        RewardStorage.Layout storage rs = RewardStorage.layout();

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(task.id != 0, "Task does not exist");
        require(rewardToken != address(0), "Invalid token address");
        require(rewardToken.code.length > 0, "Invalid token contract");
        require(totalAmount > 0, "Reward amount must be greater than 0");
        require(rs.rewardPools[taskId].totalAmount == 0, "Reward pool already exists");

        // 转移代币到合约
        IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), totalAmount);

        rs.rewardPools[taskId].taskId = taskId;
        rs.rewardPools[taskId].totalAmount = totalAmount;
        rs.rewardPools[taskId].remainingAmount = totalAmount;
        rs.rewardPools[taskId].reviewerRewardAmount = reviewerRewardAmount;
        rs.rewardPools[taskId].rewardToken = rewardToken;

        emit IReward.RewardPoolCreated(taskId, totalAmount, reviewerRewardAmount, rewardToken);
    }

    function claimReward(uint32 taskId) internal returns (uint96) {
        RewardStorage.Layout storage rs = RewardStorage.layout();
        IReward.RewardPool storage pool = rs.rewardPools[taskId];

        require(pool.taskId != 0, "Reward pool does not exist");
        require(LibTask.isTaskParticipant(taskId, msg.sender), "Not a participant of this task");
        require(rs.claimedAmounts[taskId][msg.sender] == 0, "Already claimed reward");

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(uint32(block.timestamp) > task.endTime, "Task has not ended yet");

        // Calculate reward based on completion rate
        uint32 totalDays = (task.endTime - task.startTime) / 1 days;
        uint32 completedDays = LibCheckIn.getUserCheckInCount(taskId, msg.sender);
        uint32 completionRate = (completedDays * 100) / totalDays;

        // Must complete at least 80% of check-ins to get reward
        require(completionRate >= 80, "Completion rate too low");

        // Calculate reward amount
        uint96 baseReward = (pool.totalAmount - pool.reviewerRewardAmount) / task.currentParticipants;
        uint96 rewardAmount = (baseReward * completionRate) / 100;

        // Update state
        pool.remainingAmount -= rewardAmount;
        rs.claimedAmounts[taskId][msg.sender] = rewardAmount;

        // Transfer reward
        if (pool.rewardToken == address(0)) {
            (bool success, ) = payable(msg.sender).call{value: rewardAmount}("");
            require(success, "Transfer failed");
        } else {
            IERC20(pool.rewardToken).safeTransfer(msg.sender, rewardAmount);
        }

        emit IReward.RewardClaimed(taskId, msg.sender, rewardAmount, 0, pool.rewardToken); // COMPLETION

        return rewardAmount;
    }

    function claimReviewerReward(uint32 taskId) internal returns (uint96) {
        RewardStorage.Layout storage rs = RewardStorage.layout();
        IReward.RewardPool storage pool = rs.rewardPools[taskId];

        require(pool.taskId != 0, "Reward pool does not exist");
        require(!rs.claimedReviewerRewards[taskId][msg.sender], "Already claimed reviewer reward");

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(uint32(block.timestamp) > task.endTime, "Task has not ended yet");

        // Calculate reviewer reward
        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();
        uint32 totalReviews = ps.reviewsCompleted[msg.sender];
        require(totalReviews > 0, "No reviews completed");

        uint96 rewardPerReview = pool.reviewerRewardAmount / (task.currentParticipants * totalReviews);
        uint96 rewardAmount = rewardPerReview * totalReviews;

        // Update state
        pool.remainingAmount -= rewardAmount;
        rs.claimedReviewerRewards[taskId][msg.sender] = true;

        // Transfer reward
        if (pool.rewardToken == address(0)) {
            (bool success, ) = payable(msg.sender).call{value: rewardAmount}("");
            require(success, "Transfer failed");
        } else {
            IERC20(pool.rewardToken).safeTransfer(msg.sender, rewardAmount);
        }

        emit IReward.RewardClaimed(taskId, msg.sender, rewardAmount, 1, pool.rewardToken); // REVIEW

        return rewardAmount;
    }

    function getClaimableAmount(uint32 taskId, address participant) internal view returns (uint96) {
        RewardStorage.Layout storage rs = RewardStorage.layout();

        if (rs.claimedAmounts[taskId][participant] > 0) {
            return 0;
        }

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        if (task.id == 0 || uint32(block.timestamp) <= task.endTime) {
            return 0;
        }

        uint32 totalDays = (task.endTime - task.startTime) / 1 days;
        uint32 completedDays = LibCheckIn.getUserCheckInCount(taskId, participant);
        uint32 completionRate = (completedDays * 100) / totalDays;

        if (completionRate < 80) {
            return 0;
        }

        IReward.RewardPool storage pool = rs.rewardPools[taskId];
        uint96 baseReward = (pool.totalAmount - pool.reviewerRewardAmount) / task.currentParticipants;
        return (baseReward * completionRate) / 100;
    }

    function getReviewerRewardAmount(uint32 taskId, address reviewer) internal view returns (uint96) {
        RewardStorage.Layout storage rs = RewardStorage.layout();

        if (rs.claimedReviewerRewards[taskId][reviewer]) {
            return 0;
        }

        // Get task details
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        if (task.id == 0 || uint32(block.timestamp) <= task.endTime) {
            return 0;
        }

        PeerReviewStorage.Layout storage ps = PeerReviewStorage.layout();
        uint32 totalReviews = ps.reviewsCompleted[reviewer];

        if (totalReviews == 0) {
            return 0;
        }

        IReward.RewardPool storage pool = rs.rewardPools[taskId];
        uint96 rewardPerReview = pool.reviewerRewardAmount / (task.currentParticipants * totalReviews);
        return rewardPerReview * totalReviews;
    }
}