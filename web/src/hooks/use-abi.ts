import checkInAbi from "@/constant/check-in-abi.json";
import peerReviewAbi from "@/constant/peer-review-abi.json";
import rewardAbi from "@/constant/reward-abi.json";
import diamondAbi from "@/constant/diamond-abi.json";
import taskAbi from "@/constant/task-abi.json";

export const useAbi = () => {
  return [
    ...checkInAbi,
    ...peerReviewAbi,
    ...rewardAbi,
    ...diamondAbi,
    ...taskAbi,
  ];
};
