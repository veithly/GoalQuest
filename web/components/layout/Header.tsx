import Link from "next/link";
import { Rocket } from "lucide-react";
import { ConnectButton } from "./ConnectButton";

export default function Header() {
  return (
    <header className="bg-gradient-to-r from-indigo-900 to-purple-900 text-white p-4 shadow-lg">
      <div className="container mx-auto flex items-center justify-between">
        <Link href="/" className="flex items-center space-x-2">
          <Rocket className="h-8 w-8" />
          <h1 className="text-2xl font-bold">GoalQuest</h1>
        </Link>
        <nav className="hidden md:flex space-x-6">
          <Link href="/" className="hover:text-purple-300 transition-colors">
            Explore
          </Link>
          <Link
            href="/profile"
            className="hover:text-purple-300 transition-colors"
          >
            My Missions
          </Link>
          <Link
            href="/profile#achievements"
            className="hover:text-purple-300 transition-colors"
          >
            Achievements
          </Link>
        </nav>
        <ConnectButton />
      </div>
    </header>
  );
}
