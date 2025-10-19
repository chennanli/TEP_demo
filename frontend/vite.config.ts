import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0', // Allow external connections (Safari compatible)
    port: 5173,
    headers: {
      "Cache-Control": "no-store",
    },
    proxy: {
      // Proxy API calls to FaultExplainer backend (Safari compatible)
      '/api': {
        target: 'http://127.0.0.1:8000',
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/api/, ''),  // Remove /api prefix
      }
    },
  },
});
