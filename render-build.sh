#!/usr/bin/env bash
set -o errexit

# Clear any partial/corrupted Puppeteer Chrome caches before installing
rm -rf /opt/render/.cache/puppeteer ./.cache/puppeteer

npm install --omit=dev
npx puppeteer browsers install chrome
