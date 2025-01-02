'use client';

import { Facebook, Linkedin, Send } from 'lucide-react';

function XIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
    </svg>
  );
}

export default function SocialShare() {
  const shareUrl = window.location.href;
  const title = "Join my mission on GoalQuest! 🚀";

  const sharePlatform = (platform: string) => {
    const urls = {
      x: `https://twitter.com/intent/tweet?url=${encodeURIComponent(shareUrl)}&text=${encodeURIComponent(title)}`,
      facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}`,
      linkedin: `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(shareUrl)}`,
      telegram: `https://t.me/share/url?url=${encodeURIComponent(shareUrl)}&text=${encodeURIComponent(title)}`
    };

    window.open(urls[platform], '_blank', 'width=600,height=400');
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold">Share via Social Media</h3>
      <div className="grid grid-cols-2 gap-4">
        <button
          onClick={() => sharePlatform('x')}
          className="flex items-center justify-center gap-2 bg-[#000000]/10 hover:bg-[#000000]/20 text-[#000000] p-3 rounded-lg transition-colors"
        >
          <XIcon className="w-5 h-5" />
          X
        </button>
        <button
          onClick={() => sharePlatform('telegram')}
          className="flex items-center justify-center gap-2 bg-[#0088cc]/10 hover:bg-[#0088cc]/20 text-[#0088cc] p-3 rounded-lg transition-colors"
        >
          <Send className="w-5 h-5" />
          Telegram
        </button>
        <button
          onClick={() => sharePlatform('facebook')}
          className="flex items-center justify-center gap-2 bg-[#4267B2]/10 hover:bg-[#4267B2]/20 text-[#4267B2] p-3 rounded-lg transition-colors"
        >
          <Facebook className="w-5 h-5" />
          Facebook
        </button>
        <button
          onClick={() => sharePlatform('linkedin')}
          className="flex items-center justify-center gap-2 bg-[#0077B5]/10 hover:bg-[#0077B5]/20 text-[#0077B5] p-3 rounded-lg transition-colors"
        >
          <Linkedin className="w-5 h-5" />
          LinkedIn
        </button>
      </div>
    </div>
  );
}