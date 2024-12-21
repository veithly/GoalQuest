import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const CheckinHeader = () => {
  const navigate = useNavigate();

  return (
    <div className="mb-8">
      <button
        onClick={() => navigate(-1)}
        className="flex items-center text-purple-300 hover:text-purple-200 mb-4"
      >
        <ArrowLeft className="w-5 h-5 mr-2" />
        Back to Mission
      </button>
      <h1 className="text-3xl font-bold mb-2">Daily Check-in</h1>
      <p className="text-purple-300">Record your progress for today's mission</p>
    </div>
  );
};

export default CheckinHeader;