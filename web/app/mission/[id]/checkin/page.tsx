'use client';

import { useState } from 'react';
import CheckinHeader from '@/components/checkin/CheckinHeader';
import CheckinForm from '@/components/checkin/CheckinForm';
import AIEvaluation from '@/components/checkin/AIEvaluation';

export default function DailyCheckin({ params }: { params: { id: string } }) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState<boolean | null>(null);

  const handleSubmit = async (formData: any) => {
    setIsSubmitting(true);
    // Simulate API call
    setTimeout(() => {
      setIsSuccess(true);
      setIsSubmitting(false);
    }, 2000);
  };

  return (
    <div className="container mx-auto px-4 py-6 max-w-2xl">
      <CheckinHeader />
      <CheckinForm onSubmit={handleSubmit} disabled={isSubmitting} />
      <AIEvaluation 
        isSubmitting={isSubmitting}
        isSuccess={isSuccess}
      />
    </div>
  );
}