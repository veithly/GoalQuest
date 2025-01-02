'use client';

import { useState } from 'react';
import { Copy, Check } from 'lucide-react';

export default function LinkShare() {
  const [copied, setCopied] = useState(false);
  const shareUrl = window.location.href;

  const copyToClipboard = async () => {
    try {
      await navigator.clipboard.writeText(shareUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold">Or share via link</h3>
      <div className="flex gap-2">
        <input
          type="text"
          value={shareUrl}
          readOnly
          className="flex-1 bg-indigo-950/50 rounded-lg px-4 py-2 text-sm text-purple-200"
        />
        <button
          onClick={copyToClipboard}
          className="flex items-center gap-2 bg-purple-500 hover:bg-purple-600 px-4 py-2 rounded-lg transition-colors"
        >
          {copied ? (
            <>
              <Check className="w-4 h-4" />
              Copied!
            </>
          ) : (
            <>
              <Copy className="w-4 h-4" />
              Copy
            </>
          )}
        </button>
      </div>
    </div>
  );
}