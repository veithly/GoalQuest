import React from 'react';
import { Edit2, MapPin } from 'lucide-react';

const ProfileHeader = () => {
  return (
    <div className="relative bg-gradient-to-r from-indigo-900 to-purple-900 rounded-xl p-6">
      <div className="flex flex-col md:flex-row items-center gap-6">
        <img
          src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop"
          alt="Profile"
          className="w-32 h-32 rounded-full border-4 border-purple-500"
        />
        <div className="flex-1 text-center md:text-left">
          <h1 className="text-3xl font-bold mb-2">Alex Chen</h1>
          <div className="flex items-center justify-center md:justify-start gap-2 text-purple-300 mb-4">
            <MapPin className="w-4 h-4" />
            <span>San Francisco, CA</span>
          </div>
          <p className="text-purple-200 max-w-2xl">
            Web3 developer passionate about building decentralized applications and exploring new technologies.
          </p>
        </div>
        <button className="absolute top-6 right-6 p-2 bg-purple-500/20 rounded-full hover:bg-purple-500/30 transition-colors">
          <Edit2 className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
}

export default ProfileHeader;