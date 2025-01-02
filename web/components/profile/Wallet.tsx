import React from "react";
import { Wallet2, ArrowUpRight, ArrowDownLeft } from "lucide-react";

const Wallet = () => {
  return (
    <div className="bg-indigo-900/50 rounded-xl p-6">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <Wallet2 className="w-5 h-5" />
        My Wallet
      </h2>

      <div className="bg-gradient-to-r from-purple-500/20 to-indigo-500/20 rounded-lg p-4 mb-6">
        <div className="text-sm text-purple-300 mb-1">Available Balance</div>
        <div className="text-2xl font-bold">1,234.56 FLOW</div>
      </div>

      <div className="space-y-3">
        <button className="w-full flex items-center justify-center gap-2 bg-purple-500 hover:bg-purple-600 text-white py-3 rounded-lg transition-colors">
          <ArrowUpRight className="w-4 h-4" />
          Deposit
        </button>
        <button className="w-full flex items-center justify-center gap-2 bg-indigo-900/50 hover:bg-indigo-900/70 text-white py-3 rounded-lg transition-colors">
          <ArrowDownLeft className="w-4 h-4" />
          Withdraw
        </button>
      </div>
    </div>
  );
};

export default Wallet;
