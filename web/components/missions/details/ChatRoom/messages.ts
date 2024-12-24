export interface Message {
  id: string;
  user: {
    name: string;
    avatar: string;
  };
  text: string;
  timestamp: string;
}

export const messages: Message[] = [
  {
    id: '1',
    user: {
      name: 'Alex Chen',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=50&h=50&fit=crop',
    },
    text: "Just completed today's coding challenge! 🚀",
    timestamp: '5m ago',
  },
  {
    id: '2',
    user: {
      name: 'Sarah Kim',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50&fit=crop',
    },
    text: 'Great work! What technology stack are you using?',
    timestamp: '3m ago',
  },
];