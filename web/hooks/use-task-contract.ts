import {
  useReadContract,
  useWaitForTransactionReceipt,
  useWriteContract,
} from "wagmi";
import { useAbi } from "./use-abi";
import contractAddress from "@/constant/contract-address.json";
import { parseEther } from "viem";

export function useTaskContract() {
  const abi = useAbi();

  // 读取任务列表
  const useGetUserTasks = (address?: string) => {
    return useReadContract({
      address: contractAddress.Diamond as `0x${string}`,
      abi,
      functionName: "getUserTasks",
      args: address ? [address] : undefined,
    });
  };

  // 读取任务列表
  const useGetAllTasks = () => {
    return useReadContract({
      address: contractAddress.Diamond as `0x${string}`,
      abi,
      functionName: "getAllTasks",
    });
  };

  // 读取单个任务详情
  const useGetTask = (taskId?: number) => {
    return useReadContract({
      address: contractAddress.Diamond as `0x${string}`,
      abi,
      functionName: "getTask",
      args: taskId ? [taskId] : undefined,
    });
  };

  // 创建任务
  const useCreateTask = () => {
    const { data, writeContractAsync } = useWriteContract();
    const { isLoading: isWaitLoading, isSuccess } =
      useWaitForTransactionReceipt({
        hash: data,
      });
    const handleCreateTask = async ({
      startTime,
      endTime,
      stakingAmount,
      participantsLimit,
      taskType,
      stakingToken,
      hash,
    }: {
      startTime: number;
      endTime: number;
      stakingAmount: string;
      participantsLimit: number;
      taskType: number;
      stakingToken: `0x${string}`;
      hash: string;
    }) => {
      console.log("data?.hash", data);
      try {
        writeContractAsync({
          abi,
          functionName: "createTask",
          address: contractAddress.Diamond as `0x${string}`,
          args: [
            startTime, // uint32 startTime
            endTime, // uint32 endTime
            parseEther(stakingAmount), // uint96 stakingAmount (转换为 wei)
            participantsLimit, // uint16 participantsLimit
            taskType, // uint8 taskType
            stakingToken, // address stakingToken
            hash, // string configHash
            // 'xxxxx': {name: 'name', description: 'this is a description'}
          ],
        });
      } catch (error) {
        console.error("Failed to create task:", error);
      }
    };

    return {
      createTask: handleCreateTask,
      isLoading: isWaitLoading,
      isSuccess,
      hash: data,
    };
  };

  const useJoinTask = () => {
    const { data, writeContractAsync } = useWriteContract();

    const { isLoading: isWaitLoading, isSuccess } =
      useWaitForTransactionReceipt({
        hash: data,
      });

    const handleJoinTask = async ({ taskId }: { taskId: number }) => {
      console.log("data?.hash", data);
      try {
        writeContractAsync({
          abi,
          functionName: "joinTask",
          address: contractAddress.Diamond as `0x${string}`,
          args: [
            taskId, // uint32 startTime
          ],
        });
      } catch (error) {
        console.error("Failed to create task:", error);
      }
    };

    return {
      joinTask: handleJoinTask,
      isLoading: isWaitLoading,
      isSuccess,
    };
  };

  return {
    useGetUserTasks,
    useGetTask,
    useCreateTask,
    useGetAllTasks,
    useJoinTask,
  };
}
