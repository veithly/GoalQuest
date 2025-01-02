'use client';

import { useState } from 'react';
import { Loader } from 'lucide-react';

interface StakeFormProps {
  onClose: () => void;
}

export default function StakeForm({ onClose }: StakeFormProps) {
  const [isStaking, setIsStaking] = useState(false);

  const handleStake = async () => {
    setIsStaking(true);
    try {
      // TODO: Add blockchain interaction
      await new Promise(resolve => setTimeout(resolve, 2000));
      onClose();
    } catch (error) {
      console.error('Staking failed:', error);
    } finally {
      setIsStaking(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="bg-purple-900/30 p-4 rounded-lg">
        <div className="text-sm text-purple-300 mb-1">Required Stake</div>
        <div className="text-2xl font-bold">50 MATIC</div>
      </div>

      <button
        onClick={handleStake}
        disabled={isStaking}
        className="w-full bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 text-white py-3 rounded-full font-semibold transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
      >
        {isStaking ? (
          <>
            <Loader className="w-5 h-5 animate-spin" />
            Staking...
          </>
        ) : (
          'Stake & Join Mission'
        )}
      </button>
    </div>
  );
}