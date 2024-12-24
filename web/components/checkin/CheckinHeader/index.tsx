import { ArrowLeft } from 'lucide-react';
import Link from 'next/link';

export default function CheckinHeader() {
  return (
    <div className="mb-8">
      <Link
        href="/mission/1"
        className="flex items-center text-purple-300 hover:text-purple-200 mb-4"
      >
        <ArrowLeft className="w-5 h-5 mr-2" />
        Back to Mission
      </Link>
      <h1 className="text-3xl font-bold mb-2">Daily Check-in</h1>
      <p className="text-purple-300">Record your progress for today&apos;s mission</p>
    </div>
  );
}