// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IPeerReview } from "../interfaces/IPeerReview.sol";

library PeerReviewStorage {
    bytes32 constant STORAGE_POSITION = keccak256("goalquest.storage.peer.review");

    struct Layout {
        // CheckIn ID => ReviewSession
        mapping(uint32 => IPeerReview.ReviewSession) reviewSessions;
        // CheckIn ID => Reviewer address => Review
        mapping(uint32 => mapping(address => IPeerReview.Review)) reviews;
        // User address => Total reviews completed
        mapping(address => uint32) reviewsCompleted;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            l.slot := position
        }
    }
}