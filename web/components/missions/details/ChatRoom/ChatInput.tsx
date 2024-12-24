'use client';

import { useState } from 'react';
import { Send } from 'lucide-react';

export default function ChatInput() {
  const [message, setMessage] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!message.trim()) return;
    // Handle message submission
    setMessage('');
  };

  return (
    <form onSubmit={handleSubmit} className="flex space-x-2">
      <input
        type="text"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        placeholder="Type your message..."
        className="flex-1 bg-purple-900/50 rounded-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-purple-500"
      />
      <button 
        type="submit"
        className="p-2 bg-purple-500 rounded-full hover:bg-purple-600 transition-colors"
      >
        <Send className="w-5 h-5" />
      </button>
    </form>
  );
}