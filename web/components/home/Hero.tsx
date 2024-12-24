import { Star } from 'lucide-react';

export default function Hero() {
  return (
    <div className="relative min-h-[500px] flex items-center justify-center bg-gradient-to-b from-indigo-900 via-purple-900 to-black overflow-hidden">
      {/* Animated stars background */}
      <div className="absolute inset-0">
        {[...Array(50)].map((_, i) => (
          <Star
            key={i}
            className="absolute animate-pulse text-white opacity-50"
            style={{
              top: `${Math.random() * 100}%`,
              left: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 2}s`,
              transform: `scale(${Math.random() * 0.5 + 0.5})`,
            }}
          />
        ))}
      </div>
      
      <div className="relative z-10 text-center text-white px-4">
        <h1 className="text-5xl md:text-6xl font-bold mb-6">
          Explore Your Goal Universe
        </h1>
        <p className="text-xl md:text-2xl mb-8 text-purple-200">
          Transform your goals into epic space missions
        </p>
        <button className="bg-purple-500 hover:bg-purple-600 px-8 py-3 rounded-full text-lg font-semibold transition-all transform hover:scale-105">
          Start Your Journey
        </button>
      </div>
    </div>
  );
}