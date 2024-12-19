// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Diamond.sol";
import "../src/facets/DiamondCutFacet.sol";
import "../src/facets/TaskFacet.sol";
import "../src/facets/CheckInFacet.sol";
import "../src/facets/PeerReviewFacet.sol";
import "../src/facets/RewardFacet.sol";
import "../src/interfaces/IDiamond.sol";
import "../src/interfaces/ITask.sol";
import "../src/interfaces/ICheckIn.sol";
import "../src/interfaces/IPeerReview.sol";
import "../src/interfaces/IReward.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract GoalQuestTest is Test {
    Diamond diamond;
    DiamondCutFacet diamondCutFacet;
    TaskFacet taskFacet;
    CheckInFacet checkInFacet;
    PeerReviewFacet peerReviewFacet;
    RewardFacet rewardFacet;
    MockERC20 mockToken;

    address owner = address(this);
    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3);
    address user4 = address(0x4);

    function setUp() public {
        // 部署合约
        diamondCutFacet = new DiamondCutFacet();
        diamond = new Diamond(owner, address(diamondCutFacet));
        taskFacet = new TaskFacet();
        checkInFacet = new CheckInFacet();
        peerReviewFacet = new PeerReviewFacet();
        rewardFacet = new RewardFacet();
        mockToken = new MockERC20();

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

        // 给测试用户一些代币
        mockToken.transfer(user1, 1000 * 10**18);
        mockToken.transfer(user2, 1000 * 10**18);
        mockToken.transfer(user3, 1000 * 10**18);
        mockToken.transfer(user4, 1000 * 10**18);

        // 给测试用户一些 ETH
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);
        vm.deal(user4, 100 ether);
    }

    function test_CreateTask() public {
        uint32 startTime = uint32(block.timestamp + 1 days);
        uint32 endTime = uint32(block.timestamp + 8 days);
        uint96 stakingAmount = 1 ether;
        uint16 participantsLimit = 10;
        uint8 taskType = 0; // CLASSIC
        string memory configHash = "QmHash";

        // 创建原生���币任务
        vm.prank(user1);
        uint32 taskId = ITask(address(diamond)).createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            address(0),
            configHash
        );

        ITask.Task memory task = ITask(address(diamond)).getTask(taskId);
        assertEq(task.id, taskId);
        assertEq(task.creator, user1);
        assertEq(task.stakingAmount, stakingAmount);
        assertEq(task.stakingToken, address(0));
    }

    function test_JoinTask() public {
        // 创建任务
        uint32 startTime = uint32(block.timestamp + 1 days);
        uint32 endTime = uint32(block.timestamp + 8 days);
        uint96 stakingAmount = 1 ether;
        uint16 participantsLimit = 10;
        uint8 taskType = 0; // CLASSIC
        string memory configHash = "QmHash";

        vm.prank(user1);
        uint32 taskId = ITask(address(diamond)).createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            address(0),
            configHash
        );

        // 加入任务
        vm.prank(user2);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);

        bool isParticipant = ITask(address(diamond)).isParticipant(taskId, user2);
        assertTrue(isParticipant);
    }

    function test_CheckIn() public {
        // 创建并加入任务
        uint32 startTime = uint32(block.timestamp + 1 days);
        uint32 endTime = uint32(block.timestamp + 8 days);
        uint96 stakingAmount = 1 ether;
        uint16 participantsLimit = 10;
        uint8 taskType = 0; // CLASSIC
        string memory configHash = "QmHash";

        vm.prank(user1);
        uint32 taskId = ITask(address(diamond)).createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            address(0),
            configHash
        );

        vm.prank(user2);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);

        // 时间快进到任务开始
        vm.warp(startTime);

        // 提交打卡
        vm.prank(user2);
        uint32 checkInId = ICheckIn(address(diamond)).submitCheckIn(
            taskId,
            "QmProofHash"
        );

        // AI 审核
        vm.prank(owner);
        ICheckIn(address(diamond)).updateAIReview(checkInId, 1, 90); // APPROVED

        ICheckIn.CheckIn memory checkIn = ICheckIn(address(diamond)).getCheckIn(checkInId);
        assertEq(checkIn.status, 1); // APPROVED
        assertEq(checkIn.aiScore, 90);
    }

    function test_PeerReview() public {
        // 创建并加入任务
        uint32 startTime = uint32(block.timestamp + 1 days);
        uint32 endTime = uint32(block.timestamp + 8 days);
        uint96 stakingAmount = 1 ether;
        uint16 participantsLimit = 10;
        uint8 taskType = 0; // CLASSIC
        string memory configHash = "QmHash";

        vm.prank(user1);
        uint32 taskId = ITask(address(diamond)).createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            address(0),
            configHash
        );

        // 让足够多的用户加入任务
        vm.prank(user1);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);
        vm.prank(user2);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);
        vm.prank(user3);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);
        vm.prank(user4);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);

        // 时间快进到任务开始
        vm.warp(startTime);

        // 提交打卡
        vm.prank(user1);
        uint32 checkInId = ICheckIn(address(diamond)).submitCheckIn(
            taskId,
            "QmProofHash"
        );

        // AI ���绝
        vm.prank(owner);
        ICheckIn(address(diamond)).updateAIReview(checkInId, 2, 50); // REJECTED

        // 请求同行评审
        vm.prank(user1);
        ICheckIn(address(diamond)).requestPeerReview(checkInId);

        // 分配评审者
        vm.prank(user1);
        IPeerReview(address(diamond)).assignReviewers(checkInId);

        // 提交评审
        IPeerReview.ReviewSession memory session = IPeerReview(address(diamond)).getReviewSession(checkInId);
        for (uint i = 0; i < session.reviewers.length; i++) {
            vm.prank(session.reviewers[i]);
            IPeerReview(address(diamond)).submitReview(checkInId, true, "QmReviewHash");
        }

        // 检查打卡状态
        ICheckIn.CheckIn memory checkIn = ICheckIn(address(diamond)).getCheckIn(checkInId);
        assertEq(checkIn.status, 1); // APPROVED
    }

    function test_Reward() public {
        // 创建并加入任务
        uint32 startTime = uint32(block.timestamp + 1 days);
        uint32 endTime = uint32(block.timestamp + 8 days);
        uint96 stakingAmount = 1 ether;
        uint16 participantsLimit = 10;
        uint8 taskType = 0; // CLASSIC
        string memory configHash = "QmHash";

        vm.prank(user1);
        uint32 taskId = ITask(address(diamond)).createTask(
            startTime,
            endTime,
            stakingAmount,
            participantsLimit,
            taskType,
            address(0),
            configHash
        );

        // 用户加入任务
        vm.prank(user2);
        ITask(address(diamond)).joinTask{value: stakingAmount}(taskId);

        // 创建奖励池
        uint96 reviewerRewardAmount = 0.1 ether;
        vm.prank(owner);
        IReward(address(diamond)).createRewardPool{value: 10 ether}(
            taskId,
            reviewerRewardAmount,
            address(0)
        );

        // 时间快进到任务开始
        vm.warp(startTime);

        // 每天打卡
        for (uint32 i = 0; i < 7; i++) {
            vm.prank(user2);
            uint32 checkInId = ICheckIn(address(diamond)).submitCheckIn(
                taskId,
                "QmProofHash"
            );

            vm.prank(owner);
            ICheckIn(address(diamond)).updateAIReview(checkInId, 1, 90); // APPROVED

            vm.warp(block.timestamp + 1 days);
        }

        // 时间快进到任务结束
        vm.warp(endTime + 1);

        // 领取奖励
        uint256 balanceBefore = user2.balance;
        vm.prank(user2);
        uint96 reward = IReward(address(diamond)).claimReward(taskId);
        uint256 balanceAfter = user2.balance;

        assertEq(balanceAfter - balanceBefore, reward);
    }
}