// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import { LibPeerReview } from "../libraries/LibPeerReview.sol";
import { IPeerReview } from "../interfaces/IPeerReview.sol";

contract PeerReviewFacet is IPeerReview {
    function assignReviewers(uint32 checkInId) external override returns (address[] memory) {
        return LibPeerReview.assignReviewers(checkInId);
    }

    function submitReview(
        uint32 checkInId,
        bool approved,
        string calldata proofHash
    ) external override {
        LibPeerReview.submitReview(checkInId, approved, proofHash);
    }

    function getReviewSession(uint32 checkInId) external view override returns (ReviewSession memory) {
        return LibPeerReview.getReviewSession(checkInId);
    }

    function getReview(
        uint32 checkInId,
        address reviewer
    ) external view override returns (Review memory) {
        return LibPeerReview.getReview(checkInId, reviewer);
    }

    function isReviewer(
        uint32 checkInId,
        address user
    ) external view override returns (bool) {
        return LibPeerReview.isReviewer(checkInId, user);
    }
}