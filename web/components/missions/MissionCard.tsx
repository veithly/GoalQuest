import { useTaskContract } from "@/hooks/use-task-contract";
import dayjs from "dayjs";
import { Users, Trophy, Coins } from "lucide-react";
import Link from "next/link";

interface MissionCardProps {
  id: number;
  name: string;
  taskType: string;
  description: number;
  stakingAmount: number;
  participantsLimit: number;
  currentParticipants: number;
  startTime: number;
  endTime: number;
}

export default function MissionCard(props: MissionCardProps) {
  const { useJoinTask } = useTaskContract();
  const { joinTask } = useJoinTask();
  const now = dayjs().valueOf() / 1000;

  const progress = parseInt(
    `${((now - props.startTime) / (props.endTime - props.startTime)) * 100}`
  );

  const onJoin = async () => {
    const result = await joinTask({ taskId: props.id });
    console.log("result ---> ", result);
  };

  return (
    <div className="block bg-gradient-to-br from-indigo-900 to-purple-900 rounded-lg p-6 shadow-xl hover:transform hover:scale-105 transition-all">
      <Link href={`/mission/${props.id}`}>
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-xl font-bold text-white">{props.name}</h3>
          <span className="bg-purple-500 text-white text-sm px-3 py-1 rounded-full">
            {props.taskType}
          </span>
        </div>

        <div className="space-y-4">
          <div className="flex items-center text-purple-200">
            <Users className="w-4 h-4 mr-2" />
            <span>{props.participantsLimit} Explorers</span>
          </div>

          <div className="flex items-center text-purple-200">
            <Coins className="w-4 h-4 mr-2" />
            <span>{props.stakingAmount} Staked</span>
          </div>

          <div className="relative pt-1">
            <div className="flex mb-2 items-center justify-between">
              <div className="flex items-center text-purple-200">
                <Trophy className="w-4 h-4 mr-2" />
                <span>Progress</span>
              </div>
              <span className="text-purple-200 text-right">
                {progress < 0 ? "即将开始" : `${progress}%`}
              </span>
            </div>
            <div className="overflow-hidden h-2 text-xs flex rounded bg-purple-900">
              <div
                style={{ width: `${progress < 0 ? 0 : progress}%` }}
                className="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-purple-500"
              />
            </div>
          </div>
        </div>
      </Link>

      <button
        onClick={onJoin}
        className="w-full mt-6 bg-purple-500 hover:bg-purple-600 text-white py-2 rounded-full transition-colors cursor-pointer"
      >
        Join Mission
      </button>
    </div>
  );
}
