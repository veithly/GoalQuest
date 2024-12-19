// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Diamond.sol";
import "../src/facets/DiamondCutFacet.sol";
import "../src/facets/TaskFacet.sol";
import "../src/facets/CheckInFacet.sol";
import "../src/facets/PeerReviewFacet.sol";
import "../src/facets/RewardFacet.sol";
import "../src/interfaces/IDiamond.sol";

contract GoalQuestScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 部署 DiamondCutFacet
        DiamondCutFacet diamondCutFacet = new DiamondCutFacet();

        // 部署 Diamond
        Diamond diamond = new Diamond(msg.sender, address(diamondCutFacet));

        // 部署其他 Facets
        TaskFacet taskFacet = new TaskFacet();
        CheckInFacet checkInFacet = new CheckInFacet();
        PeerReviewFacet peerReviewFacet = new PeerReviewFacet();
        RewardFacet rewardFacet = new RewardFacet();

        // 准备 diamondCut 数据
        IDiamond.FacetCut[] memory cut = new IDiamond.FacetCut[](4);

        // TaskFacet
        bytes4[] memory taskSelectors = new bytes4[](6);
        taskSelectors[0] = TaskFacet.createTask.selector;
        taskSelectors[1] = TaskFacet.joinTask.selector;
        taskSelectors[2] = TaskFacet.joinTaskWithToken.selector;
        taskSelectors[3] = TaskFacet.getTask.selector;
        taskSelectors[4] = TaskFacet.getUserTasks.selector;
        taskSelectors[5] = TaskFacet.isParticipant.selector;

        cut[0] = IDiamond.FacetCut({
            facetAddress: address(taskFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: taskSelectors
        });

        // CheckInFacet
        bytes4[] memory checkInSelectors = new bytes4[](5);
        checkInSelectors[0] = CheckInFacet.submitCheckIn.selector;
        checkInSelectors[1] = CheckInFacet.updateAIReview.selector;
        checkInSelectors[2] = CheckInFacet.requestPeerReview.selector;
        checkInSelectors[3] = CheckInFacet.getCheckIn.selector;
        checkInSelectors[4] = CheckInFacet.getUserDailyCheckIn.selector;

        cut[1] = IDiamond.FacetCut({
            facetAddress: address(checkInFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: checkInSelectors
        });

        // PeerReviewFacet
        bytes4[] memory peerReviewSelectors = new bytes4[](5);
        peerReviewSelectors[0] = PeerReviewFacet.assignReviewers.selector;
        peerReviewSelectors[1] = PeerReviewFacet.submitReview.selector;
        peerReviewSelectors[2] = PeerReviewFacet.getReviewSession.selector;
        peerReviewSelectors[3] = PeerReviewFacet.getReview.selector;
        peerReviewSelectors[4] = PeerReviewFacet.isReviewer.selector;

        cut[2] = IDiamond.FacetCut({
            facetAddress: address(peerReviewFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: peerReviewSelectors
        });

        // RewardFacet
        bytes4[] memory rewardSelectors = new bytes4[](6);
        rewardSelectors[0] = RewardFacet.createRewardPool.selector;
        rewardSelectors[1] = RewardFacet.createRewardPoolWithToken.selector;
        rewardSelectors[2] = RewardFacet.claimReward.selector;
        rewardSelectors[3] = RewardFacet.claimReviewerReward.selector;
        rewardSelectors[4] = RewardFacet.getClaimableAmount.selector;
        rewardSelectors[5] = RewardFacet.getReviewerRewardAmount.selector;

        cut[3] = IDiamond.FacetCut({
            facetAddress: address(rewardFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: rewardSelectors
        });

        // 添加所有 facets
        IDiamond(address(diamond)).diamondCut(cut, address(0), "");

        vm.stopBroadcast();
    }
}