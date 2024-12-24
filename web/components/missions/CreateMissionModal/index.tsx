'use client';

import { X } from 'lucide-react';
import { useState } from 'react';
import MissionForm from './MissionForm';

interface CreateMissionModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function CreateMissionModal({ isOpen, onClose }: CreateMissionModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div className="bg-indigo-900/90 rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-6 border-b border-purple-700">
          <h2 className="text-2xl font-bold">Create New Mission</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-purple-800 rounded-full transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        <MissionForm onClose={onClose} />
      </div>
    </div>
  );
}