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

# Flow 测试网部署指南

## 1. 环境准备

首先设置必要的环境变量:

```bash
# 设置部署账户私钥
export PRIVATE_KEY=your_private_key

# Flow 测试网 RPC
export RPC_URL=https://testnet.evm.nodes.onflow.org
```

## 2. 手动部署步骤

### 2.1 部署 DiamondCutFacet

```bash
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/facets/DiamondCutFacet.sol:DiamondCutFacet \
  --legacy
```

保存返回的合约地址: `DIAMOND_CUT_ADDRESS`

### 2.2 部署 Diamond

```bash
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/Diamond.sol:Diamond \
  --constructor-args $DEPLOYER_ADDRESS $DIAMOND_CUT_ADDRESS \
  --legacy
```

保存返回的合约地址: `DIAMOND_ADDRESS`

### 2.3 部署其他 Facets

```bash
# 部署 TaskFacet
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/facets/TaskFacet.sol:TaskFacet \
  --legacy

# 部署 CheckInFacet
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/facets/CheckInFacet.sol:CheckInFacet \
  --legacy

# 部署 PeerReviewFacet
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/facets/PeerReviewFacet.sol:PeerReviewFacet \
  --legacy

# 部署 RewardFacet
forge create --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  src/facets/RewardFacet.sol:RewardFacet \
  --legacy
```

### 2.4 执行 Diamond Cut

部署完所有 Facets 后，需要执行 Diamond Cut 将它们添加到 Diamond 合约中：

```bash
export DIAMOND_ADDRESS=0x3D2e2f5e2760Af62a06C640c38Df8f82E13d02a6
export DIAMOND_CUT_ADDRESS=0x9ECD7a3Ee1Db83c2D18F4592Ab496950DAc401D9
export TASK_FACET_ADDRESS=0x7F2d645aC1c821a94E3c46cd19DfeB582cBFa9B1
export CHECKIN_FACET_ADDRESS=0x1ef302A9EbC8f3D7Bd38cc9AdC40eB38E6862C42
export PEER_REVIEW_FACET_ADDRESS=0xf67f40e1bB89D2C4b006DF0c7e944872023D2840
export REWARD_FACET_ADDRESS=0x6Dec7D60f7A38DA254Ef2299aDCa7C497BF7b318

forge script script/GoalQuest.s.sol:GoalQuestScript \
  --sig "executeDiamondCut()" \
  --rpc-url $RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY
```

注意：
1. 需要替换所有的 Facet 地址变量
2. function selectors 需要根据实际合约接口生成
3. 确保 selector 数组顺序与合约中定义的顺序一致

## 3. 合约验证

使用 Blockscout 验证器验证每个合约:

### 3.1 验证 DiamondCutFacet

```bash
forge verify-contract --rpc-url $RPC_URL \
  --verifier blockscout \
  --verifier-url https://evm-testnet.flowscan.io/api \
  $DIAMOND_CUT_ADDRESS \
  src/facets/DiamondCutFacet.sol:DiamondCutFacet
```

### 3.2 验证 Diamond

```bash
forge verify-contract --rpc-url $RPC_URL \
  --verifier blockscout \
  --verifier-url https://evm-testnet.flowscan.io/api \
  --constructor-args $(cast abi-encode "constructor(address,address)" $DEPLOYER_ADDRESS $DIAMOND_CUT_ADDRESS) \
  $DIAMOND_ADDRESS \
  src/Diamond.sol:Diamond
```

### 3.3 验证其他 Facets

对每个 Facet 重复类似的验证命令:

```bash
forge verify-contract --rpc-url $RPC_URL \
  --verifier blockscout \
  --verifier-url https://evm-testnet.flowscan.io/api \
  $FACET_ADDRESS \
  src/facets/[FacetName].sol:[FacetName]
```

## 4. 验证部署

部署完成后,可以通过以下方式验证:

1. 在 Flow Testnet Explorer 查看合约代码和交互
2. 使用 cast 调用合约方法进行测试
3. 运行测试脚本验证功能完整性

## 5. 升级Facet

### 5.1 更新TaskFacet

```bash
forge script script/UpdateTaskFacet.s.sol:UpdateFacetScript --sig "updateTaskFacet()" \
  --rpc-url $RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY \
  --legacy
```

## 注意事项

1. 确保使用 `--legacy` 标志以兼容 Flow EVM
2. 记录所有部署的合约地址
3. 验证每个步骤的交易确认
4. 保存构造函数参数以便验证
5. 检查 gas 限制和价格设置
