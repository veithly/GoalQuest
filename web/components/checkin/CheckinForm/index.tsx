'use client';

import { useState } from 'react';
import { Link } from 'lucide-react';
import FileUpload from '../FileUpload';

interface CheckinFormData {
  text: string;
  files: File[];
}

interface CheckinFormProps {
  onSubmit?: (data: CheckinFormData) => void;
  disabled?: boolean;
}

export default function CheckinForm({ onSubmit, disabled }: CheckinFormProps) {
  const [text, setText] = useState('');
  const [files, setFiles] = useState<File[]>([]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit?.({ text, files });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div>
        <label className="block text-sm font-medium text-purple-300 mb-2">
          Today&apos;s Progress
        </label>
        <textarea
          value={text}
          onChange={(e) => setText(e.target.value)}
          className="w-full h-32 bg-indigo-900/50 rounded-lg p-4 text-white placeholder-purple-400 focus:ring-2 focus:ring-purple-500 focus:outline-none"
          placeholder="Share your achievements for today..."
          disabled={disabled}
        />
      </div>

      <FileUpload
        onFilesSelected={setFiles}
        disabled={disabled}
      />

      <button
        type="button"
        className="w-full flex items-center justify-center space-x-2 bg-indigo-900/50 text-purple-300 p-4 rounded-lg hover:bg-indigo-800/50 transition-colors"
        disabled={disabled}
      >
        <Link className="w-5 h-5" />
        <span>Connect Third-Party App</span>
      </button>

      <button
        type="submit"
        disabled={disabled}
        className="w-full bg-gradient-to-r from-purple-500 to-indigo-500 text-white py-4 rounded-full font-semibold hover:from-purple-600 hover:to-indigo-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {disabled ? 'Submitting...' : 'Submit Check-in'}
      </button>
    </form>
  );
}