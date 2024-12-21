import React from 'react';
import ProfileHeader from '../components/profile/ProfileHeader';
import MyMissions from '../components/profile/MyMissions';
import Achievements from '../components/profile/Achievements';
import Wallet from '../components/profile/Wallet';
import NFTGallery from '../components/profile/NFTGallery';
import Settings from '../components/profile/Settings';

const Profile = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <ProfileHeader />
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mt-8">
        <div className="lg:col-span-2 space-y-8">
          <MyMissions />
          <Achievements />
          <NFTGallery />
        </div>
        <div className="space-y-8">
          <Wallet />
          <Settings />
        </div>
      </div>
    </div>
  );
};

export default Profile;