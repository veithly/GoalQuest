import { Rocket } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

const Header = () => {
  const navigate = useNavigate();
  const { user, loggedIn, logIn, logOut } = useAuth();

  return (
    <header className="bg-gradient-to-r from-indigo-900 to-purple-900 text-white p-4 shadow-lg">
      <div className="container mx-auto flex items-center justify-between">
        <div
          className="flex items-center space-x-2 cursor-pointer"
          onClick={() => navigate(`/`)}
        >
          <Rocket className="h-8 w-8" />
          <h1 className="text-2xl font-bold">GoalQuest</h1>
        </div>
        <nav className="hidden md:flex space-x-6">
          <a href="#" className="hover:text-purple-300 transition-colors">
            Explore
          </a>
          <a href="#" className="hover:text-purple-300 transition-colors">
            My Missions
          </a>
          <a href="#" className="hover:text-purple-300 transition-colors">
            Achievements
          </a>
        </nav>

        {loggedIn ? (
          <div className="space-y-4">
            <p className="connected-text">
              Connected as:{" "}
              <span className="connected-username">{user?.addr}</span>
            </p>
            <button onClick={logOut} className="button button-disconnect">
              Disconnect Wallet
            </button>
          </div>
        ) : (
          <button
            onClick={logIn}
            className="bg-purple-500 hover:bg-purple-600 px-4 py-2 rounded-full transition-colors"
          >
            Connect Wallet
          </button>
        )}
      </div>
    </header>
  );
};

export default Header;
