import React, { useState } from 'react';
import { Send } from 'lucide-react';

interface Message {
  id: string;
  user: {
    name: string;
    avatar: string;
  };
  text: string;
  timestamp: string;
}

const messages: Message[] = [
  {
    id: '1',
    user: {
      name: 'Alex Chen',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=50&h=50&fit=crop',
    },
    text: 'Just completed today\'s coding challenge! 🚀',
    timestamp: '5m ago',
  },
  {
    id: '2',
    user: {
      name: 'Sarah Kim',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50&fit=crop',
    },
    text: 'Great work! What technology stack are you using?',
    timestamp: '3m ago',
  },
];

const ChatRoom = () => {
  const [message, setMessage] = useState('');

  return (
    <div className="bg-indigo-900/50 rounded-lg p-6">
      <h2 className="text-xl font-bold mb-4">Mission Chat</h2>
      
      <div className="space-y-4 mb-4 max-h-[300px] overflow-y-auto">
        {messages.map((msg) => (
          <div key={msg.id} className="flex space-x-3">
            <img
              src={msg.user.avatar}
              alt={msg.user.name}
              className="w-8 h-8 rounded-full"
            />
            <div>
              <div className="flex items-baseline space-x-2">
                <span className="font-medium">{msg.user.name}</span>
                <span className="text-xs text-purple-300">{msg.timestamp}</span>
              </div>
              <p className="text-purple-200">{msg.text}</p>
            </div>
          </div>
        ))}
      </div>
      
      <div className="flex space-x-2">
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Type your message..."
          className="flex-1 bg-purple-900/50 rounded-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-purple-500"
        />
        <button className="p-2 bg-purple-500 rounded-full hover:bg-purple-600 transition-colors">
          <Send className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
};

export default ChatRoom;