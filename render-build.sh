#!/usr/bin/env bash
# Optional Render Build Script for Native Node.js Runtime (Docker is recommended via Dockerfile)
set -o errexit

echo "Installing standalone Render backend dependencies..."
npm install --omit=dev

echo "Installing Chromium browser for whatsapp-web.js..."
export PUPPETEER_CACHE_DIR=/opt/render/project/src/.cache/puppeteer
npx puppeteer browsers install chrome || true

echo "Render server build complete!"
