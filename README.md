# WhatsApp Broadcast Backend (Backend-Only Deployment)

Self-contained Node.js + Chromium API server (`whatsapp-web.js`) for **WhatsApp Personal Broadcast Desk**. Contains only the backend server and deployment configuration—no frontend assets.

## Included Files
- `server.js` — Express API (`/api/health`, `/api/status`, `/api/whatsapp/connect`, `/api/whatsapp/disconnect`, `/api/contacts/parse-csv`, `/api/send`, `/api/firebase-config`) with CORS, Firebase ID token + TSDC SSO verification, subscription check, stale Chromium lock cleanup, and graceful shutdown.
- `package.json` — Backend-only dependencies (`express`, `firebase-admin`, `multer`, `qrcode`, `whatsapp-web.js`).
- `firebase-applet-config.json` — Firebase project configuration.
- `Dockerfile` — Node 20 + Chromium container image.
- `render.yaml` — Render Blueprint configuration.
- `Procfile` — Standard process file (`web: node server.js`).
- `.env.example` — Environment variables reference.

## Deploy Option 1: Docker (Any Cloud / VPS / Cloud Run / Railway / Fly.io)
```bash
cd whatsapp-backend
docker build -t whatsapp-broadcast-backend .
docker run -d -p 3000:3000 -v wa_auth:/app/.wwebjs_auth --name wa-backend whatsapp-broadcast-backend
```

## Deploy Option 2: Render (using Root Directory or Standalone Repo)
1. Push this folder (or the repository) to GitHub.
2. On [dashboard.render.com](https://dashboard.render.com), click **New +** → **Web Service**.
3. Set **Root Directory** to `whatsapp-backend` (or deploy directly if pushed to its own repo).
4. Choose **Runtime**: **Docker**.
5. Optional: Attach a persistent disk mounted at `/app/.wwebjs_auth` (and set `WA_AUTH_PATH=/app/.wwebjs_auth`) to preserve WhatsApp pairing across restarts.
6. Deploy and verify `https://<your-backend-url>/api/health`.

## Connect to Your Frontend Dashboard
1. Open your deployed Broadcast Desk frontend (e.g. Cloudflare Pages / `broadcast.tsdc.in`).
2. Click the **BACKEND** status pill in the top header (or open **WhatsApp Connect** → **Configure Backend**).
3. Enter your deployed backend URL (e.g. `https://your-backend.onrender.com`), click **Test Connection**, and **Save & Apply**.
