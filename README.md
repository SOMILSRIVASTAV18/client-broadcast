# WhatsApp Broadcast Backend — Render Deployment Guide

Standalone backend-only Node.js + Chromium API server (`whatsapp-web.js`) for **WhatsApp Personal Broadcast Desk**. Contains only the backend server and Render deployment configuration (no frontend assets).

---

## Recommended: Deploy on Render with Docker
Render's **Native Node** environment does not include Chromium's Linux system libraries (`libnss3`, `libgbm1`, etc.) and shares `/opt/render/.cache/puppeteer` across failed builds. Using **Docker** avoids Puppeteer download/cache errors completely.

1. Push the contents of `whatsapp-backend/` to your GitHub repo (or set **Root Directory** to `whatsapp-backend`).
2. In [Render Dashboard](https://dashboard.render.com), **Settings → Build & Deploy** (or **New + → Web Service**):
   - **Language / Runtime**: **Docker** *(do not select Node)*
   - **Dockerfile Path**: `Dockerfile`
   - **Health Check Path**: `/api/health`
3. Click **Manual Deploy → Clear build cache & deploy** (or **Create Web Service**).
4. Verify `https://<your-service>.onrender.com/api/health` returns `{"status":"ok","whatsappReady":true,...}`.

> **Persistent WhatsApp Sessions (Paid Render Plans):** Attach a Persistent Disk at `/app/.wwebjs_auth` and set `WA_AUTH_PATH=/app/.wwebjs_auth`.

---

## Option 2: Deploy via Render Blueprint (`render.yaml`)
If `whatsapp-backend` files are at the root of your repository, create a **New + → Blueprint** in Render and select the repo. `render.yaml` automatically selects **Docker**, Node 20 + system Chromium, and `/api/health`.

---

## Option 3: If Using Render Native Node.js Runtime
If you keep **Language: Node** on Render instead of Docker:
- `.puppeteerrc.cjs` stores Puppeteer's browser inside `./.cache/puppeteer` (avoiding `/opt/render/.cache/puppeteer` corruption and bundling Chrome into the runtime slug).
- `package.json` pins `engines.node` to `20.x`.
- Set **Build Command**: `chmod +x ./render-build.sh && ./render-build.sh`
- Set **Start Command**: `node server.js`
- Make sure `PUPPETEER_SKIP_DOWNLOAD` and `PUPPETEER_EXECUTABLE_PATH` are **not** set in Render Environment Variables when using Native Node.

---

## Connect Your Frontend Dashboard
1. Open your deployed **WhatsApp Personal Broadcast Desk** frontend.
2. Click **BACKEND** in the header (or **WhatsApp Connect → Configure Backend**).
3. Enter your Render URL (`https://<your-service>.onrender.com`), click **Test Connection**, and **Save & Apply**.
