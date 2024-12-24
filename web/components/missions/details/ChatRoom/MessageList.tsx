import Image from 'next/image';
import type { Message } from './messages';

interface MessageListProps {
  messages: Message[];
}

export default function MessageList({ messages }: MessageListProps) {
  return (
    <div className="space-y-4 mb-4 max-h-[300px] overflow-y-auto">
      {messages.map((msg) => (
        <div key={msg.id} className="flex space-x-3">
          <div className="relative w-8 h-8">
            <Image
              src={msg.user.avatar}
              alt={msg.user.name}
              fill
              className="rounded-full object-cover"
            />
          </div>
          <div>
            <div className="flex items-baseline space-x-2">
              <span className="font-medium">{msg.user.name}</span>
              <span className="text-xs text-purple-300">{msg.timestamp}</span>
            </div>
            <p className="text-purple-200">{msg.text}</p>
          </div>
        </div>
      ))}
    </div>
  );
}