import React from 'react';
import { Rocket, XCircle } from 'lucide-react';

interface AIEvaluationProps {
  isSubmitting: boolean;
  isSuccess: boolean | null;
}

const AIEvaluation: React.FC<AIEvaluationProps> = ({ isSubmitting, isSuccess }) => {
  if (!isSubmitting && !isSuccess) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black/50 backdrop-blur-sm">
      <div className="bg-indigo-900/90 p-8 rounded-2xl max-w-md w-full mx-4 text-center">
        {isSubmitting ? (
          <>
            <div className="animate-pulse mb-4">
              <Rocket className="w-12 h-12 mx-auto text-purple-400" />
            </div>
            <h3 className="text-xl font-bold mb-2">AI Evaluation in Progress</h3>
            <p className="text-purple-300">
              Our AI is analyzing your check-in data...
            </p>
          </>
        ) : isSuccess ? (
          <>
            <div className="animate-bounce mb-4">
              <Rocket className="w-12 h-12 mx-auto text-green-400" />
            </div>
            <h3 className="text-xl font-bold text-green-400 mb-2">
              Check-in Successful!
            </h3>
            <p className="text-purple-300">
              Great work! Keep up the momentum on your mission.
            </p>
          </>
        ) : (
          <>
            <div className="mb-4">
              <XCircle className="w-12 h-12 mx-auto text-red-400" />
            </div>
            <h3 className="text-xl font-bold text-red-400 mb-2">
              Check-in Failed
            </h3>
            <p className="text-purple-300">
              Something went wrong. Please try again.
            </p>
          </>
        )}
      </div>
    </div>
  );
};

export default AIEvaluation;