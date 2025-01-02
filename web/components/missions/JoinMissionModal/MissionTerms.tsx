export default function MissionTerms() {
  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold">Mission Terms</h3>
      <div className="bg-indigo-950/50 rounded-lg p-4 space-y-3 text-purple-200">
        <p>By joining this mission, you agree to:</p>
        <ul className="list-disc list-inside space-y-2">
          <li>Stake 50 MATIC as commitment</li>
          <li>Complete daily check-ins</li>
          <li>Follow mission guidelines</li>
          <li>Support other participants</li>
        </ul>
        <p className="text-sm">
          Note: Staked amount will be returned based on mission completion criteria
        </p>
      </div>
    </div>
  );
}