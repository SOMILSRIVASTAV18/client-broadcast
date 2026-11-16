const { join } = require('path');

/**
 * Puppeteer configuration for Render (both Docker and Native Node deployments).
 * - Stores Chrome inside the project directory so Render includes it in the deploy slug
 *   and avoids corrupted global /opt/render/.cache/puppeteer build-cache folders.
 * - Skips downloading Chrome when system Chromium is configured (Docker / PUPPETEER_EXECUTABLE_PATH).
 */
module.exports = {
  cacheDirectory: join(__dirname, '.cache', 'puppeteer'),
  skipDownload:
    process.env.PUPPETEER_SKIP_DOWNLOAD === 'true' ||
    process.env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD === 'true' ||
    Boolean(process.env.PUPPETEER_EXECUTABLE_PATH),
};
