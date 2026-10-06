import { defineConfig } from "vite";
import path from "node:path";

export default defineConfig(({ command }) => {
  const isDev = command === "serve";

  return {
    root: import.meta.dirname,
    base: isDev ? "/" : "/dist/",
    server: {
      // 5174, not Vite's default 5173, so this site can run next to AiPoc
      port: 5174,
      strictPort: true
    },
    build: {
      outDir: path.resolve(import.meta.dirname, "../wwwroot/dist"),
      emptyOutDir: true,
      manifest: true,
      rollupOptions: {
        input: path.resolve(import.meta.dirname, "main.ts")
      }
    }
  };
});
