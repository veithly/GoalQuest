import React from 'react';
import { useParams } from 'react-router-dom';
import CheckinHeader from '../components/checkin/CheckinHeader';
import CheckinForm from '../components/checkin/CheckinForm';
import AIEvaluation from '../components/checkin/AIEvaluation';

const DailyCheckin = () => {
  const { id } = useParams();
  const [isSubmitting, setIsSubmitting] = React.useState(false);
  const [isSuccess, setIsSuccess] = React.useState<boolean | null>(null);

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
};

export default DailyCheckin;