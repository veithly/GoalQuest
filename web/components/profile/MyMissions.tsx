"use client";
import React, { useEffect } from "react";
import { Rocket } from "lucide-react";
import { useTaskContract } from "@/hooks/use-task-contract";
import { useAccount } from "wagmi";

const missions = [
  {
    id: "1",
    title: "30 Days of Coding",
    progress: 65,
    status: "active",
  },
  {
    id: "2",
    title: "Web3 Development",
    progress: 45,
    status: "active",
  },
  {
    id: "3",
    title: "Daily Meditation",
    progress: 100,
    status: "completed",
  },
];

const MyMissions = () => {
  const { useGetUserTasks } = useTaskContract();
  const { address } = useAccount();
  const { data } = useGetUserTasks(address);
  console.log("--- > data", data);

  return (
    <div className="bg-indigo-900/50 rounded-xl p-6">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <Rocket className="w-5 h-5" />
        My Missions
      </h2>
      <div className="space-y-4">
        {missions.map((mission) => (
          <div
            key={mission.id}
            className="bg-indigo-900/30 rounded-lg p-4 hover:bg-indigo-900/40 transition-colors cursor-pointer"
          >
            <div className="flex justify-between items-center mb-2">
              <h3 className="font-semibold">{mission.title}</h3>
              <span
                className={`px-3 py-1 rounded-full text-sm ${
                  mission.status === "completed"
                    ? "bg-green-500/20 text-green-300"
                    : "bg-purple-500/20 text-purple-300"
                }`}
              >
                {mission.status}
              </span>
            </div>
            <div className="w-full bg-indigo-900/50 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${
                  mission.status === "completed"
                    ? "bg-green-500"
                    : "bg-purple-500"
                }`}
                style={{ width: `${mission.progress}%` }}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default MyMissions;
