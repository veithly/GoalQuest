import MissionDetailsHeader from "../components/missions/details/MissionDetailsHeader";
import MissionDescription from "../components/missions/details/MissionDescription";
import ParticipantsList from "../components/missions/details/ParticipantsList";
import CheckInSection from "../components/missions/details/CheckInSection";
import ChatRoom from "../components/missions/details/ChatRoom";

const MissionDetails = () => {
  return (
    <div className="min-h-screen bg-black text-white">
      <MissionDetailsHeader />

      <div className="container mx-auto px-4 py-6">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <MissionDescription />
            <ParticipantsList />
            <ChatRoom />
          </div>

          <div className="space-y-6">
            <CheckInSection />
            <button className="w-full bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 text-white py-4 rounded-full font-semibold transition-colors">
              Join Mission
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MissionDetails;
