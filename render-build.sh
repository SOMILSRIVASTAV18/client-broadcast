#!/usr/bin/env bash
set -o errexit

npm install --omit=dev
npx puppeteer browsers install chrome
