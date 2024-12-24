import React from 'react';
import { Trophy, Star, Award } from 'lucide-react';

const achievements = [
  {
    id: '1',
    title: 'Early Explorer',
    description: 'One of the first 100 users',
    icon: Star,
    rarity: 'legendary',
  },
  {
    id: '2',
    title: 'Mission Master',
    description: 'Completed 5 missions',
    icon: Trophy,
    rarity: 'rare',
  },
  {
    id: '3',
    title: 'Perfect Streak',
    description: '30 days without missing a check-in',
    icon: Award,
    rarity: 'epic',
  },
];

const rarityColors = {
  legendary: 'from-yellow-500 to-orange-500',
  epic: 'from-purple-500 to-pink-500',
  rare: 'from-blue-500 to-indigo-500',
};

const Achievements = () => {
  return (
    <div className="bg-indigo-900/50 rounded-xl p-6">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <Trophy className="w-5 h-5" />
        Achievements
      </h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {achievements.map((achievement) => {
          const Icon = achievement.icon;
          return (
            <div
              key={achievement.id}
              className={`bg-gradient-to-br ${rarityColors[achievement.rarity]} p-[1px] rounded-lg`}
            >
              <div className="bg-indigo-900/90 p-4 rounded-lg h-full">
                <Icon className="w-8 h-8 mb-3" />
                <h3 className="font-semibold mb-1">{achievement.title}</h3>
                <p className="text-sm text-purple-300">{achievement.description}</p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default Achievements;