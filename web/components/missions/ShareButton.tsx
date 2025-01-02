'use client';

import { useState } from 'react';
import { Share2 } from 'lucide-react';
import ShareModal from './ShareModal';

export default function ShareButton() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <button 
        onClick={() => setIsOpen(true)}
        className="p-2 hover:bg-purple-800 rounded-full transition-colors"
        aria-label="Share mission"
      >
        <Share2 className="w-5 h-5" />
      </button>
      <ShareModal isOpen={isOpen} onClose={() => setIsOpen(false)} />
    </>
  );
}