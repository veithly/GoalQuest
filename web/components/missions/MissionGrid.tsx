"use client";
import { useTaskContract } from "@/hooks/use-task-contract";
import MissionCard from "./MissionCard";
import { useEffect, useState } from "react";
import { formatUnits } from "viem";

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

export default function MissionGrid() {
  const [missionJsonData, setMissionJsonData] = useState<MissionCardProps[]>(
    []
  );

  const { useGetAllTasks } = useTaskContract();
  const { data: missions } = useGetAllTasks();

  const updateMisson = () => {
    if (Array.isArray(missions)) {
      console.log(missions, "<---missions");
      const jsonData = missions
        ?.filter((m: { configHash: string }) => m.configHash.includes("{"))
        .map((m: { configHash: string; stakingAmount: bigint }) => {
          return {
            ...m,

            ...JSON.parse(m.configHash),
            stakingAmount: formatUnits(m.stakingAmount, 18),
          };
        });

      console.log("jsonData", jsonData);
      setMissionJsonData(jsonData);
    }
  };

  useEffect(() => {
    if (missions) {
      updateMisson();
    }
  }, [missions]);

  return (
    <div className="container mx-auto px-4 py-12">
      <h2 className="text-3xl font-bold text-white mb-8">Active Missions</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {missionJsonData?.map((mission) => {
          console.log("mission.id", mission.id);
          console.log("mission", mission);
          return <MissionCard key={mission.id} {...mission} />;
        })}
      </div>
    </div>
  );
}
