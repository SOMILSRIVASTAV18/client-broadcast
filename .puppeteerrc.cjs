const { join } = require('path');

/**
 * Store Puppeteer's Chrome download inside the project directory rather than
 * /opt/render/.cache/puppeteer so Render includes the browser in the runtime slug
 * and avoids corrupted global cache directories.
 * Ignored automatically when PUPPETEER_SKIP_DOWNLOAD=true (e.g. Docker).
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  cacheDirectory: join(__dirname, '.cache', 'puppeteer'),
};
