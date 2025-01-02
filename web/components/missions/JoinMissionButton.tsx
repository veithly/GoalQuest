'use client';

import { useState } from 'react';
import JoinMissionModal from './JoinMissionModal';

export default function JoinMissionButton() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <button 
        onClick={() => setIsOpen(true)}
        className="w-full bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 text-white py-4 rounded-full font-semibold transition-colors"
      >
        Join Mission
      </button>
      <JoinMissionModal isOpen={isOpen} onClose={() => setIsOpen(false)} />
    </>
  );
}