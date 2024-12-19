// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import { LibReward } from "../libraries/LibReward.sol";
import { IReward } from "../interfaces/IReward.sol";

contract RewardFacet is IReward {
    function createRewardPool(
        uint32 taskId,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) external payable override {
        LibReward.createRewardPool(taskId, reviewerRewardAmount, rewardToken);
    }

    function createRewardPoolWithToken(
        uint32 taskId,
        uint96 totalAmount,
        uint96 reviewerRewardAmount,
        address rewardToken
    ) external override {
        LibReward.createRewardPoolWithToken(taskId, totalAmount, reviewerRewardAmount, rewardToken);
    }

    function claimReward(uint32 taskId) external override returns (uint96) {
        return LibReward.claimReward(taskId);
    }

    function claimReviewerReward(uint32 taskId) external override returns (uint96) {
        return LibReward.claimReviewerReward(taskId);
    }

    function getClaimableAmount(
        uint32 taskId,
        address participant
    ) external view override returns (uint96) {
        return LibReward.getClaimableAmount(taskId, participant);
    }

    function getReviewerRewardAmount(
        uint32 taskId,
        address reviewer
    ) external view override returns (uint96) {
        return LibReward.getReviewerRewardAmount(taskId, reviewer);
    }
}