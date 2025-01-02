"use client";

import { Plus } from "lucide-react";
import { useState } from "react";
import CreateMissionModal from "./CreateMissionModal";

export default function CreateMissionButton() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className="flex items-center gap-2 bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 px-6 py-3 rounded-full text-white font-semibold transition-all"
      >
        <Plus className="w-5 h-5" />
        Create
      </button>
      <CreateMissionModal isOpen={isOpen} onClose={() => setIsOpen(false)} />
    </>
  );
}
