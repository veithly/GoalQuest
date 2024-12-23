// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ITask {
    struct Task {
        uint32 id;              // 支持超过 40 亿个任务
        uint32 startTime;       // Unix timestamp
        uint32 endTime;         // Unix timestamp
        uint96 stakingAmount;   // 质押金额
        uint16 participantsLimit; // 最大支持 65535 人参与
        uint16 currentParticipants;
        address creator;
        uint8 flags;           // 使用位运算存储多个布尔值
        uint8 taskType;        // 任务类型
        address stakingToken;  // 质押代币地址，address(0) 表示原生代币
        string configHash;     // IPFS hash，存储任务的详细配置
    }

    // flags 位定义:
    // bit 0: isActive
    // bit 1-7: 预留给未来使用

    event TaskCreated(
        uint32 indexed taskId,
        address indexed creator,
        uint96 stakingAmount,
        address stakingToken,
        string configHash
    );

    event TaskJoined(
        uint32 indexed taskId,
        address indexed participant,
        uint96 stakingAmount,
        address stakingToken
    );

    event TaskCompleted(
        uint32 indexed taskId,
        address indexed participant,
        uint96 reward
    );

    function createTask(
        uint32 startTime,
        uint32 endTime,
        uint96 stakingAmount,
        uint16 participantsLimit,
        uint8 taskType,
        address stakingToken,
        string calldata configHash
    ) external returns (uint32);

    function joinTask(uint32 taskId) external payable;
    function joinTaskWithToken(uint32 taskId) external;
    function getTask(uint32 taskId) external view returns (Task memory);
    function getUserTasks(address user) external view returns (uint32[] memory);
    function isParticipant(uint32 taskId, address user) external view returns (bool);
    function getAllTasks() external view returns (Task[] memory);
}