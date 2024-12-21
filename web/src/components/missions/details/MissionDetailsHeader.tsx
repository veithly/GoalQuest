import React from 'react';
import { ArrowLeft, Share2, MoreHorizontal } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const MissionDetailsHeader = () => {
  const navigate = useNavigate();

  return (
    <div className="bg-gradient-to-r from-indigo-900 to-purple-900 p-4">
      <div className="container mx-auto flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <button 
            onClick={() => navigate(-1)}
            className="p-2 hover:bg-purple-800 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold">30 Days of Coding</h1>
        </div>
        <div className="flex items-center space-x-2">
          <button className="p-2 hover:bg-purple-800 rounded-full transition-colors">
            <Share2 className="w-5 h-5" />
          </button>
          <button className="p-2 hover:bg-purple-800 rounded-full transition-colors">
            <MoreHorizontal className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
};

export default MissionDetailsHeader;