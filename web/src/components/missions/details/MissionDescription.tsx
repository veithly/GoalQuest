import React from 'react';
import { Calendar, Target, CheckSquare, Trophy, Coins, Medal } from 'lucide-react';

const MissionDescription = () => {
  return (
    <div className="bg-indigo-900/50 rounded-lg p-6 space-y-6">
      <div className="space-y-4">
        <div className="flex items-start space-x-3">
          <Target className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">Mission Objective</h3>
            <p className="text-purple-200">Code for at least 1 hour every day for 30 days to build consistent coding habits.</p>
          </div>
        </div>

        <div className="flex items-start space-x-3">
          <CheckSquare className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">Check-in Requirements</h3>
            <p className="text-purple-200">Share a screenshot of your code or GitHub contributions daily.</p>
          </div>
        </div>

        <div className="flex items-start space-x-3">
          <Calendar className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">Mission Duration</h3>
            <p className="text-purple-200">March 1, 2024 - March 30, 2024</p>
          </div>
        </div>
      </div>

      <div className="border-t border-purple-700 pt-6 space-y-4">
        <div className="flex items-start space-x-3">
          <Coins className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">Reward Pool</h3>
            <p className="text-purple-200">Current Pool: 1500 MATIC</p>
          </div>
        </div>

        <div className="flex items-start space-x-3">
          <Trophy className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">Reward Distribution</h3>
            <ul className="text-purple-200 list-disc list-inside">
              <li>Complete all 30 days: 80% of stake returned + bonus</li>
              <li>Miss up to 3 days: 50% of stake returned</li>
              <li>Miss more than 3 days: No stake return</li>
            </ul>
          </div>
        </div>

        <div className="flex items-start space-x-3">
          <Medal className="w-5 h-5 mt-1 text-purple-400" />
          <div>
            <h3 className="font-semibold mb-2">NFT Achievement</h3>
            <div className="bg-purple-900/50 p-4 rounded-lg">
              <img 
                src="https://images.unsplash.com/photo-1614728263952-84ea256f9679?w=150&h=150&fit=crop" 
                alt="NFT Badge" 
                className="w-20 h-20 rounded-lg mx-auto mb-2"
              />
              <p className="text-center text-sm text-purple-200">Coding Warrior NFT Badge</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MissionDescription;