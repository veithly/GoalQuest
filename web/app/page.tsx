import Hero from "@/components/home/Hero";
import CreateMissionButton from "@/components/missions/CreateMissionButton";
import MissionGrid from "@/components/missions/MissionGrid";

export default function Home() {
  return (
    <main>
      <Hero />
      <div className="container mx-auto px-4 py-12">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-white">Active Missions</h2>
          <CreateMissionButton />
        </div>
        <MissionGrid />
      </div>
    </main>
  );
}