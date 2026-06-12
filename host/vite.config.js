import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
import federation from "@originjs/vite-plugin-federation";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  const remoteUrl = env.VITE_REMOTE_URL || "http://localhost:4173";

  return {
    plugins: [
      react(),
      federation({
        name: "hostApp",
        remotes: {
          upsellRemote: {
            external: `${remoteUrl}/assets/remoteEntry.js`,
            from: "vite",
            format: "esm",
          },
        },
        shared: ["react", "react-dom"],
      }),
    ],
    build: {
      modulePreload: false,
      target: "esnext",
      minify: false,
      cssCodeSplit: false,
    },
  };
});
