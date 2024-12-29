"use client";
import { useTaskContract } from "@/hooks/use-task-contract";
import MissionCard from "./MissionCard";
// import { missions } from "@/lib/data/missions";
import { contractAddress } from "@/constant/contract-address";
import { useAccount } from "wagmi";
import { useEffect, useState } from "react";
import { d } from "@/lib/helia";
import { formatUnits } from "viem";

export default function MissionGrid() {
  const [missionJsonData, setMissionJsonData] = useState([]);

  const { useGetAllTasks } = useTaskContract();
  const account = useAccount();
  const { data: missions } = useGetAllTasks();

  const updateMisson = () => {
    console.log(missions, "<---missions");
    const jsonData = missions
      .filter((m) => m.configHash.includes("{"))
      .map((m) => {
        return {
          ...m,

          ...JSON.parse(m.configHash),
          stakingAmount: formatUnits(m.stakingAmount, 18),
        };
      });

    console.log("jsonData", jsonData);
    setMissionJsonData(jsonData);
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
