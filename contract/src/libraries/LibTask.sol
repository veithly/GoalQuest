// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ITask } from "../interfaces/ITask.sol";
import { TaskStorage } from "../storage/TaskStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

library LibTask {
    using SafeERC20 for IERC20;

    function createTask(
        uint32 startTime,
        uint32 endTime,
        uint96 stakingAmount,
        uint16 participantsLimit,
        uint8 taskType,
        address stakingToken,
        string calldata configHash
    ) internal returns (uint32) {
        TaskStorage.Layout storage ts = TaskStorage.layout();

        require(startTime > uint32(block.timestamp), "Start time must be in the future");
        require(endTime > startTime, "End time must be after start time");
        require(stakingAmount > 0, "Staking amount must be greater than 0");
        require(participantsLimit > 0, "Participants limit must be greater than 0");
        require(bytes(configHash).length > 0, "Config hash cannot be empty");

        // 如果使用 ERC20 代币，验证代币合约地址
        if (stakingToken != address(0)) {
            require(stakingToken.code.length > 0, "Invalid token contract");
        }

        uint32 taskId = ++ts.taskCounter;
        uint8 flags = 1; // Set isActive flag to true

        ts.tasks[taskId] = ITask.Task({
            id: taskId,
            startTime: startTime,
            endTime: endTime,
            stakingAmount: stakingAmount,
            participantsLimit: participantsLimit,
            currentParticipants: 0,
            creator: msg.sender,
            flags: flags,
            taskType: taskType,
            stakingToken: stakingToken,
            configHash: configHash
        });

        ts.userTasks[msg.sender].push(taskId);

        emit ITask.TaskCreated(taskId, msg.sender, stakingAmount, stakingToken, configHash);

        return taskId;
    }

    function joinTask(uint32 taskId) internal {
        TaskStorage.Layout storage ts = TaskStorage.layout();
        ITask.Task storage task = ts.tasks[taskId];

        require(task.id != 0, "Task does not exist");
        require(task.flags & 1 == 1, "Task is not active"); // Check isActive flag
        require(!ts.isParticipant[taskId][msg.sender], "Already joined this task");
        require(task.currentParticipants < task.participantsLimit, "Task is full");
        require(uint32(block.timestamp) < task.startTime, "Task has already started");

        // 如果质押金额为0，直接加入任务
        if (task.stakingAmount == 0) {
            _joinTask(ts, task, taskId);
            return;
        }

        // 处理代币转移
        if (task.stakingToken == address(0)) {
            // 转移原生代币
            require(msg.value == task.stakingAmount, "Incorrect staking amount");
        } else {
            // 转移 ERC20 代币
            require(msg.value == 0, "Native token not accepted for ERC20 task");
            IERC20(task.stakingToken).safeTransferFrom(
                msg.sender,
                address(this),
                task.stakingAmount
            );
        }

        _joinTask(ts, task, taskId);
    }

    function _joinTask(
        TaskStorage.Layout storage ts,
        ITask.Task storage task,
        uint32 taskId
    ) private {
        ts.taskParticipants[taskId].push(msg.sender);
        ts.isParticipant[taskId][msg.sender] = true;
        ts.userTasks[msg.sender].push(taskId);
        ts.totalStaked[taskId] += task.stakingAmount;
        task.currentParticipants++;

        emit ITask.TaskJoined(taskId, msg.sender, task.stakingAmount, task.stakingToken);
    }

    function getTask(uint32 taskId) internal view returns (ITask.Task storage) {
        TaskStorage.Layout storage ts = TaskStorage.layout();
        require(ts.tasks[taskId].id != 0, "Task does not exist");
        return ts.tasks[taskId];
    }

    function getUserTasks(address user) internal view returns (ITask.Task[] memory) {
        TaskStorage.Layout storage ts = TaskStorage.layout();
        uint32[] memory taskIds = ts.userTasks[user];

        // 创建一个固定大小的数组来存储所有有效的任务
        ITask.Task[] memory tasks = new ITask.Task[](taskIds.length);
        uint32 validTaskCount = 0;

        // 遍历用户的所有任务ID
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint32 taskId = taskIds[i];
            ITask.Task storage task = ts.tasks[taskId];
            if (task.id != 0) {  // 任务存在
                tasks[validTaskCount] = task;
                validTaskCount++;
            }
        }

        // 创建一个新数组，只包含有效的任务
        ITask.Task[] memory validTasks = new ITask.Task[](validTaskCount);
        for (uint256 i = 0; i < validTaskCount; i++) {
            validTasks[i] = tasks[i];
        }

        return validTasks;
    }

    function getTaskParticipants(uint32 taskId) internal view returns (address[] memory) {
        return TaskStorage.layout().taskParticipants[taskId];
    }

    function isTaskParticipant(uint32 taskId, address user) internal view returns (bool) {
        return TaskStorage.layout().isParticipant[taskId][user];
    }

    function getTotalStaked(uint32 taskId) internal view returns (uint96) {
        return TaskStorage.layout().totalStaked[taskId];
    }

    // 新增：获取所有任务列表
    function getAllTasks() internal view returns (ITask.Task[] memory) {
        TaskStorage.Layout storage ts = TaskStorage.layout();
        uint32 totalTasks = ts.taskCounter;

        // 创建一个固定大小的数组来存储所有有效的任务
        ITask.Task[] memory allTasks = new ITask.Task[](totalTasks);
        uint32 validTaskCount = 0;

        // 遍历所有可能的任务ID
        for (uint32 i = 1; i <= totalTasks; i++) {
            ITask.Task storage task = ts.tasks[i];
            if (task.id != 0) {  // 任务存在
                allTasks[validTaskCount] = task;
                validTaskCount++;
            }
        }

        return allTasks;
    }
}