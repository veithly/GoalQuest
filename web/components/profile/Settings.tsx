import React from 'react';
import { Settings as SettingsIcon, Bell, HelpCircle, Shield } from 'lucide-react';

const settingsItems = [
  {
    icon: Shield,
    title: 'Account Settings',
    description: 'Manage your account details and preferences',
  },
  {
    icon: Bell,
    title: 'Notifications',
    description: 'Control your notification preferences',
  },
  {
    icon: HelpCircle,
    title: 'Help Center',
    description: 'Get help and support',
  },
];

const Settings = () => {
  return (
    <div className="bg-indigo-900/50 rounded-xl p-6">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <SettingsIcon className="w-5 h-5" />
        Settings
      </h2>
      <div className="space-y-4">
        {settingsItems.map((item) => {
          const Icon = item.icon;
          return (
            <button
              key={item.title}
              className="w-full flex items-start gap-4 bg-indigo-900/30 p-4 rounded-lg hover:bg-indigo-900/50 transition-colors text-left"
            >
              <Icon className="w-5 h-5 mt-1 text-purple-400" />
              <div>
                <div className="font-medium">{item.title}</div>
                <div className="text-sm text-purple-300">{item.description}</div>
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default Settings;