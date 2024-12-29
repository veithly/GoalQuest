import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { http } from "wagmi";
import { flowTestnet } from "wagmi/chains";

export const config = getDefaultConfig({
  appName: "goalQuest",
  projectId: "a0bcd3d138e800850fa55ed9c4aedf69",
  chains: [flowTestnet],
  transports: {
    [flowTestnet.id]: http(),
  },
  ssr: true,
});
