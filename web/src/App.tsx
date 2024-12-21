import { BrowserRouter, Routes, Route } from "react-router-dom";
import Header from "./components/layout/Header";
import Home from "./pages/Home";
import MissionDetails from "./pages/MissionDetails";
import DailyCheckin from "./pages/DailyCheckin";
import Profile from "./pages/Profile";
import { AuthContextProvider } from "@/context/AuthContext";
import "../flow-config";

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-black text-white">
        <AuthContextProvider>
          <Header />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/mission/:id" element={<MissionDetails />} />
            <Route path="/mission/:id/checkin" element={<DailyCheckin />} />
            <Route path="/profile" element={<Profile />} />
          </Routes>
        </AuthContextProvider>
      </div>
    </BrowserRouter>
  );
}

export default App;
