// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Diamond} from "../src/Diamond.sol";
import {DiamondCutFacet} from "../src/facets/DiamondCutFacet.sol";
import {TaskFacet} from "../src/facets/TaskFacet.sol";
import {CheckInFacet} from "../src/facets/CheckInFacet.sol";
import {PeerReviewFacet} from "../src/facets/PeerReviewFacet.sol";
import {RewardFacet} from "../src/facets/RewardFacet.sol";
import {IDiamond} from "../src/interfaces/IDiamond.sol";

contract GoalQuestScript is Script {
    // 存储部署的合约地址
    address public diamondAddress;
    address public taskFacetAddress;
    address public checkInFacetAddress;
    address public peerReviewFacetAddress;
    address public rewardFacetAddress;

    function setUp() public {}

    // 部署基础合约
    function deployBase() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        DiamondCutFacet diamondCutFacet = new DiamondCutFacet();
        console2.log("DiamondCutFacet deployed at:", address(diamondCutFacet));

        // 等待第一个交易被确认
        vm.sleep(10 seconds);

        Diamond diamond = new Diamond(deployer, address(diamondCutFacet));
        diamondAddress = address(diamond);
        console2.log("Diamond deployed at:", diamondAddress);

        vm.stopBroadcast();
    }

    // 部署 Facets
    function deployFacets() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TaskFacet taskFacet = new TaskFacet();
        taskFacetAddress = address(taskFacet);
        console2.log("TaskFacet deployed at:", taskFacetAddress);
        vm.sleep(20 seconds);

        CheckInFacet checkInFacet = new CheckInFacet();
        checkInFacetAddress = address(checkInFacet);
        console2.log("CheckInFacet deployed at:", checkInFacetAddress);
        vm.sleep(20 seconds);

        PeerReviewFacet peerReviewFacet = new PeerReviewFacet();
        peerReviewFacetAddress = address(peerReviewFacet);
        console2.log("PeerReviewFacet deployed at:", peerReviewFacetAddress);
        vm.sleep(20 seconds);

        RewardFacet rewardFacet = new RewardFacet();
        rewardFacetAddress = address(rewardFacet);
        console2.log("RewardFacet deployed at:", rewardFacetAddress);

        vm.stopBroadcast();
    }

    // 执行 Diamond Cut
    function executeDiamondCut() public {
        diamondAddress = vm.envAddress("DIAMOND_ADDRESS");
        taskFacetAddress = vm.envAddress("TASK_FACET_ADDRESS");
        checkInFacetAddress = vm.envAddress("CHECKIN_FACET_ADDRESS");
        peerReviewFacetAddress = vm.envAddress("PEER_REVIEW_FACET_ADDRESS");
        rewardFacetAddress = vm.envAddress("REWARD_FACET_ADDRESS");

        require(diamondAddress != address(0), "Diamond not deployed");
        require(taskFacetAddress != address(0), "TaskFacet not deployed");
        require(checkInFacetAddress != address(0), "CheckInFacet not deployed");
        require(peerReviewFacetAddress != address(0), "PeerReviewFacet not deployed");
        require(rewardFacetAddress != address(0), "RewardFacet not deployed");

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 准备 diamondCut 数据
        IDiamond.FacetCut[] memory cut = new IDiamond.FacetCut[](4);

        // TaskFacet
        bytes4[] memory taskSelectors = new bytes4[](7);
        taskSelectors[0] = TaskFacet.createTask.selector;
        taskSelectors[1] = TaskFacet.joinTask.selector;
        taskSelectors[2] = TaskFacet.joinTaskWithToken.selector;
        taskSelectors[3] = TaskFacet.getTask.selector;
        taskSelectors[4] = TaskFacet.getUserTasks.selector;
        taskSelectors[5] = TaskFacet.isParticipant.selector;
        taskSelectors[6] = TaskFacet.getAllTasks.selector;

        cut[0] = IDiamond.FacetCut({
            facetAddress: address(taskFacetAddress),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: taskSelectors
        });

        // CheckInFacet
        bytes4[] memory checkInSelectors = new bytes4[](5);
        checkInSelectors[0] = CheckInFacet.submitCheckIn.selector;
        checkInSelectors[1] = CheckInFacet.getCheckIn.selector;
        checkInSelectors[2] = CheckInFacet.updateAIReview.selector;
        checkInSelectors[3] = CheckInFacet.requestPeerReview.selector;
        checkInSelectors[4] = CheckInFacet.getCheckInsByTask.selector;

        cut[1] = IDiamond.FacetCut({
            facetAddress: address(checkInFacetAddress),
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
            facetAddress: address(peerReviewFacetAddress),
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
            facetAddress: address(rewardFacetAddress),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: rewardSelectors
        });

        // 添加所有 facets
        IDiamond(diamondAddress).diamondCut(cut, address(0), "");
        console2.log("Diamond cut completed");

        vm.stopBroadcast();
    }
}
