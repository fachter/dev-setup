// @ts-check
// https://github.com/johnste/finicky/wiki/Configuration-(v4)

/**
 * @typedef {import("/Applications/Finicky.app/Contents/Resources/finicky.d.ts").FinickyConfig} FinickyConfig
 */

// Hosts that require an Accenture login. Add more as they show up.
const accentureHosts = ["accenture.com"];

/**
 * @param {URL} url
 * @param {string[]} hosts
 */
function matchesHost(url, hosts) {
  return hosts.some(
    (host) => url.hostname === host || url.hostname.endsWith(`.${host}`),
  );
}

/** @type {FinickyConfig} */
export default {
  defaultBrowser: "Zen",
  handlers: [
    {
      match: (url) => matchesHost(url, accentureHosts),
      browser: "Google Chrome",
    },
  ],
};
