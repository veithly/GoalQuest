import React from 'react';

interface Participant {
  id: string;
  name: string;
  avatar: string;
  progress: number;
}

const participants: Participant[] = [
  {
    id: '1',
    name: 'Alex Chen',
    avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=50&h=50&fit=crop',
    progress: 85,
  },
  {
    id: '2',
    name: 'Sarah Kim',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50&fit=crop',
    progress: 92,
  },
  {
    id: '3',
    name: 'Mike Johnson',
    avatar: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=50&h=50&fit=crop',
    progress: 78,
  },
];

const ParticipantsList = () => {
  return (
    <div className="bg-indigo-900/50 rounded-lg p-6">
      <h2 className="text-xl font-bold mb-4">Explorers</h2>
      <div className="space-y-4">
        {participants.map((participant) => (
          <div key={participant.id} className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <img
                src={participant.avatar}
                alt={participant.name}
                className="w-10 h-10 rounded-full"
              />
              <span className="font-medium">{participant.name}</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="w-32 bg-purple-900 rounded-full h-2">
                <div
                  className="bg-purple-500 h-2 rounded-full"
                  style={{ width: `${participant.progress}%` }}
                />
              </div>
              <span className="text-sm text-purple-200">{participant.progress}%</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ParticipantsList;