#!/usr/bin/env bash
# Optional Render Build Script for Native Node.js Runtime (Docker is recommended via Dockerfile)
set -o errexit

echo "Installing standalone Render backend dependencies..."
export PUPPETEER_CACHE_DIR="$(pwd)/.cache/puppeteer"
npm install --omit=dev

echo "Ensuring Chromium browser for whatsapp-web.js..."
npx puppeteer browsers install chrome || true

echo "Render server build complete!"
