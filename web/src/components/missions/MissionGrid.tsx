import React from 'react';
import MissionCard from './MissionCard';

const missions = [
  {
    id: "1",
    title: "30 Days of Coding",
    category: "Learning",
    participants: 156,
    stake: 50,
    progress: 65,
  },
  {
    id: "2",
    title: "Web3 Development",
    category: "Tech",
    participants: 89,
    stake: 100,
    progress: 45,
  },
  {
    id: "3",
    title: "Daily Meditation",
    category: "Wellness",
    participants: 234,
    stake: 30,
    progress: 80,
  },
  {
    id: "4",
    title: "Fitness Challenge",
    category: "Health",
    participants: 312,
    stake: 75,
    progress: 25,
  },
];

const MissionGrid = () => {
  return (
    <div className="container mx-auto px-4 py-12">
      <h2 className="text-3xl font-bold text-white mb-8">Active Missions</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {missions.map((mission) => (
          <MissionCard key={mission.id} {...mission} />
        ))}
      </div>
    </div>
  );
};

export default MissionGrid;