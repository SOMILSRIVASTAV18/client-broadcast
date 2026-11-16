# Cloudflare Pages + Render Deployment Guide

This setup keeps your **static dashboard frontend on Cloudflare Pages** (`broadcast.tsdc.in`) and your **WhatsApp Web + Chromium backend in this standalone `/render-server` folder on Render.com**.

---

## Part 1: Deploy Frontend on Cloudflare Pages / Workers

Deploy the repository root to Cloudflare:

- **Cloudflare Pages settings**:
  - **Build command**: `npm run build`
  - **Build output directory**: `.` (root directory, or leave blank if using `wrangler.jsonc`)
- **Cloudflare Workers Assets (`wrangler.jsonc`)**:
  - **Build command**: `npm run build`
  - **Deploy command**: `npx wrangler deploy`
- The static site automatically handles TSDC SSO (`auth.tsdc.in`), subscription checks (`apps.tsdc.in`), and lets users connect to your Render backend URL.

---

## Part 2: Deploy Standalone Backend on Render (`/render-server`)

### Option A: Deploy directly from this repository (Recommended)
1. Push your repository to GitHub / GitLab.
2. Open [dashboard.render.com](https://dashboard.render.com) → **New +** → **Web Service**.
3. Connect your repository and configure:
   - **Name**: `whatsapp-broadcast-backend`
   - **Root Directory**: `render-server`
   - **Language / Runtime**: **Docker** *(recommended — installs Chromium automatically)*
   - **Health Check Path**: `/api/health`
   - **Instance Type**: **Free** (or **Starter** with a Persistent Disk mounted at `/var/data` for always-on WhatsApp sessions)
4. Click **Create Web Service**.

*(Alternative Native Node runtime without Docker: set Build Command to `bash render-build.sh` and Start Command to `npm start`.)*

### Option B: Deploy `/render-server` from its own standalone repository
1. Copy everything inside `/render-server` into a separate Git repository.
2. On Render, create a **New Web Service** (or **New +** → **Blueprint** using `render.yaml`), select **Docker**, and deploy.

### Optional Persistence (Render Starter + Disk)
If you attach a Render Persistent Disk at `/var/data`, add these environment variables in Render:
- `WA_AUTH_PATH=/var/data/.wwebjs_auth`
- `WORKSPACE_DATA_PATH=/var/data/store.json`

---

## Part 3: Link Cloudflare Frontend to Your Render Backend

1. Copy your live Render URL, for example:
   `https://whatsapp-broadcast-backend.onrender.com`
2. Verify it responds by opening `https://whatsapp-broadcast-backend.onrender.com/api/health` in your browser.
3. Open your Cloudflare Pages dashboard (`https://broadcast.tsdc.in` or `*.pages.dev`).
4. Click the **"BACKEND: OFFLINE"** pill in the top header (or **Connect Server** on WhatsApp Connect).
5. Paste your Render HTTPS URL into **Node.js Backend Server URL**, then click **Test Connection** → **Save & Apply**.
6. Click **Start Pairing / Generate QR** and scan the QR code in WhatsApp → Linked Devices.
