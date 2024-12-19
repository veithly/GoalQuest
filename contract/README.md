# GoalQuest 智能合约

GoalQuest 是一个基于区块链的任务质押打卡平台，让用户在共同目标的激励下，养成好习惯，并获得代币奖励。

## 特点

- 使用 Diamond Pattern (EIP-2535) 实现可升级合约
- 支持原生代币和 ERC20 代币质押
- AI 自动审核 + 同行评审机制
- 完善的奖励分配机制

## 合约架构

项目使用 Diamond Pattern 进行模块化设计，主要包含以下模块：

- **TaskFacet**: 任务管理模块
  - 创建任务
  - 加入任务
  - 查询任务信息

- **CheckInFacet**: 打卡管理模块
  - 提交打卡
  - AI 审核
  - 查询打卡记录

- **PeerReviewFacet**: 同行评审模块
  - 分配评审者
  - 提交评审
  - 查询评审信息

- **RewardFacet**: 奖励管理模块
  - 创建奖励池
  - 领取任务奖励
  - 领取评审奖励

## 开发环境

- Solidity: ^0.8.13
- Foundry
- OpenZeppelin Contracts

## 安装依赖

```bash
# 安装 forge-std
forge install foundry-rs/forge-std --no-commit

# 安装 OpenZeppelin Contracts
forge install OpenZeppelin/openzeppelin-contracts --no-commit

# 安装 OpenZeppelin Contracts Upgradeable
forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit

# 更新所有依赖
forge update
```

## 编译合约

```bash
forge build
```

## 运行测试

```bash
forge test
```

## 部署

1. 设置环境变量：

```bash
export PRIVATE_KEY=your_private_key
export RPC_URL=your_rpc_url
```

2. 部署合约：

```bash
forge script script/GoalQuest.s.sol:GoalQuestScript --rpc-url $RPC_URL --broadcast --verify
```

## 测试覆盖

主要测试用例包括：

- 任务创建和加入
- 打卡提交和 AI 审核
- 同行评审流程
- 奖励分配和领取

## 安全性

- 使用 OpenZeppelin 的安全合约
- 实现访问控制
- 资金安全保护
- 完善的状态检查

## 许可证

MIT
