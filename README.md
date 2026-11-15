# WhatsApp Broadcast Backend — Render Deployment Guide

Standalone backend-only Node.js + Chromium API server (`whatsapp-web.js`) for **WhatsApp Personal Broadcast Desk**. Contains only the backend server and Render deployment configuration (no frontend assets).

## Included Files
- `server.js` — Express API (`/api/health`, `/api/status`, `/api/whatsapp/connect`, `/api/whatsapp/disconnect`, `/api/contacts/parse-csv`, `/api/send`, `/api/firebase-config`) with CORS, Firebase ID token + TSDC SSO verification, subscription verification, stale Chromium lock cleanup, and graceful shutdown.
- `package.json` — Minimal backend-only dependencies (`express`, `firebase-admin`, `multer`, `qrcode`, `whatsapp-web.js`).
- `firebase-applet-config.json` — Firebase project configuration.
- `Dockerfile` — Render-ready Node 20 + system Chromium + `tini` container image.
- `render.yaml` — One-click Render Blueprint configuration.
- `render-build.sh` — Build script for Render Native Node.js runtime.
- `Procfile` — Standard process command (`web: node server.js`).
- `.env.example` — Environment variables template.

---

## Option 1: Deploy to Render via Web Service (Docker — Recommended)
1. Push this repo (or copy the `whatsapp-backend/` folder into its own GitHub repository).
2. In [Render Dashboard](https://dashboard.render.com), click **New +** → **Web Service** and select your repository.
3. Configure:
   - **Root Directory**: `whatsapp-backend` *(leave blank if `whatsapp-backend` is pushed as its own repo)*
   - **Runtime**: **Docker**
   - **Health Check Path**: `/api/health`
   - **Environment Variables** *(optional overrides; baked into `Dockerfile`)*:
     - `HOST` = `0.0.0.0`
     - `NODE_ENV` = `production`
     - `FIREBASE_PROJECT_ID` = `leafy-brook-mwpgt`
     - `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD` = `true`
     - `PUPPETEER_EXECUTABLE_PATH` = `/usr/bin/chromium`
4. Click **Create Web Service**.
5. Once live, verify `https://<your-service>.onrender.com/api/health` returns `{"status":"ok","whatsappReady":true,...}`.

> **Tip (Persistent Sessions):** On a paid Render instance, attach a Persistent Disk mounted at `/app/.wwebjs_auth` and set `WA_AUTH_PATH=/app/.wwebjs_auth` so paired WhatsApp sessions survive restarts/deploys.

---

## Option 2: Deploy via Render Blueprint (`render.yaml`)
- If `whatsapp-backend` is the root of its own repository, click **New +** → **Blueprint** in Render and select that repo—`render.yaml` configures everything automatically.

---

## Option 3: Deploy via Render Native Node.js Runtime
If you prefer Native Node instead of Docker:
- **Root Directory**: `whatsapp-backend`
- **Runtime**: `Node`
- **Build Command**: `chmod +x ./render-build.sh && ./render-build.sh`
- **Start Command**: `node server.js`
- **Environment Variables**:
  - `PUPPETEER_CACHE_DIR` = `/opt/render/project/src/.cache/puppeteer`
  - `HOST` = `0.0.0.0`
  - `FIREBASE_PROJECT_ID` = `leafy-brook-mwpgt`

---

## Connect Your Frontend Dashboard
1. Open your deployed **WhatsApp Personal Broadcast Desk** frontend.
2. Click **BACKEND** in the header (or go to **WhatsApp Connect** → **Configure Backend**).
3. Paste your Render backend URL (`https://<your-service>.onrender.com`), click **Test Connection**, then **Save & Apply**.
