// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IReward } from "../interfaces/IReward.sol";

library RewardStorage {
    bytes32 constant STORAGE_POSITION = keccak256("goalquest.storage.reward");

    struct Layout {
        // Task ID => RewardPool
        mapping(uint32 => IReward.RewardPool) rewardPools;
        // Task ID => User address => Claimed amount
        mapping(uint32 => mapping(address => uint96)) claimedAmounts;
        // Task ID => User address => Claimed reviewer reward
        mapping(uint32 => mapping(address => bool)) claimedReviewerRewards;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            l.slot := position
        }
    }
}