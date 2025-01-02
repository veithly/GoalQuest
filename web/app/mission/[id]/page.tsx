import MissionDetailsHeader from '@/components/missions/details/MissionDetailsHeader'
import MissionDescription from '@/components/missions/details/MissionDescription'
import ParticipantsList from '@/components/missions/details/ParticipantsList'
import CheckInSection from '@/components/missions/details/CheckInSection'
import ChatRoom from '@/components/missions/details/ChatRoom'
import JoinMissionButton from '@/components/missions/JoinMissionButton'

export default function MissionDetails({params}: {params: {id: string}}) {
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
            <JoinMissionButton />
          </div>
        </div>
      </div>
    </div>
  )
}
