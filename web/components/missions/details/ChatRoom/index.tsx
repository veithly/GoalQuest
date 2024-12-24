import MessageList from './MessageList';
import ChatInput from './ChatInput';
import { messages } from './messages';

export default function ChatRoom() {
  return (
    <div className="bg-indigo-900/50 rounded-lg p-6">
      <h2 className="text-xl font-bold mb-4">Mission Chat</h2>
      <MessageList messages={messages} />
      <ChatInput />
    </div>
  );
}