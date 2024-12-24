import React from 'react';
import { Medal } from 'lucide-react';

const nfts = [
  {
    id: '1',
    title: 'Coding Warrior',
    image: 'https://images.unsplash.com/photo-1614728263952-84ea256f9679?w=150&h=150&fit=crop',
    rarity: 'legendary',
  },
  {
    id: '2',
    title: 'Meditation Master',
    image: 'https://images.unsplash.com/photo-1528715471579-d1bcf0ba5e83?w=150&h=150&fit=crop',
    rarity: 'epic',
  },
  {
    id: '3',
    title: 'Early Adopter',
    image: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=150&h=150&fit=crop',
    rarity: 'rare',
  },
];

const NFTGallery = () => {
  return (
    <div className="bg-indigo-900/50 rounded-xl p-6">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <Medal className="w-5 h-5" />
        NFT Collection
      </h2>
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        {nfts.map((nft) => (
          <div
            key={nft.id}
            className="group relative bg-indigo-900/30 rounded-lg p-3 hover:bg-indigo-900/50 transition-all cursor-pointer"
          >
            <img
              src={nft.image}
              alt={nft.title}
              className="w-full aspect-square object-cover rounded-lg mb-2"
            />
            <h3 className="font-medium text-sm text-center">{nft.title}</h3>
            <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity rounded-lg flex items-center justify-center">
              <span className="text-sm font-semibold uppercase tracking-wider">
                {nft.rarity}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default NFTGallery;