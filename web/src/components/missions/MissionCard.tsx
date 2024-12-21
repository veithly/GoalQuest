import React from 'react';
import { Users, Trophy, Coins } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

interface MissionCardProps {
  id: string;
  title: string;
  category: string;
  participants: number;
  stake: number;
  progress: number;
}

const MissionCard: React.FC<MissionCardProps> = ({
  id,
  title,
  category,
  participants,
  stake,
  progress,
}) => {
  const navigate = useNavigate();

  return (
    <div 
      onClick={() => navigate(`/mission/${id}`)}
      className="bg-gradient-to-br from-indigo-900 to-purple-900 rounded-lg p-6 shadow-xl hover:transform hover:scale-105 transition-all cursor-pointer"
    >
      <div className="flex justify-between items-start mb-4">
        <h3 className="text-xl font-bold text-white">{title}</h3>
        <span className="bg-purple-500 text-white text-sm px-3 py-1 rounded-full">
          {category}
        </span>
      </div>
      
      <div className="space-y-4">
        <div className="flex items-center text-purple-200">
          <Users className="w-4 h-4 mr-2" />
          <span>{participants} Explorers</span>
        </div>
        
        <div className="flex items-center text-purple-200">
          <Coins className="w-4 h-4 mr-2" />
          <span>{stake} MATIC Staked</span>
        </div>
        
        <div className="relative pt-1">
          <div className="flex mb-2 items-center justify-between">
            <div className="flex items-center text-purple-200">
              <Trophy className="w-4 h-4 mr-2" />
              <span>Progress</span>
            </div>
            <span className="text-purple-200 text-right">{progress}%</span>
          </div>
          <div className="overflow-hidden h-2 text-xs flex rounded bg-purple-900">
            <div
              style={{ width: `${progress}%` }}
              className="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-purple-500"
            ></div>
          </div>
        </div>
      </div>
      
      <button className="w-full mt-6 bg-purple-500 hover:bg-purple-600 text-white py-2 rounded-full transition-colors">
        Join Mission
      </button>
    </div>
  );
};

export default MissionCard;