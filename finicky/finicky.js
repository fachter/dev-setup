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

/**
 * Teams and Outlook Safe Links hide the real URL in a `url` query parameter.
 * @param {URL} url
 * @returns {URL | null}
 */
function unwrapSafelink(url) {
  const host = url.hostname;
  const isTeamsSafelink =
    (host === "teams.public.onecdn.static.microsoft" ||
      host === "statics.teams.cdn.office.net") &&
    url.pathname.includes("/safelinks/");
  const isOutlookSafelink =
    host === "safelinks.protection.outlook.com" ||
    host.endsWith(".safelinks.protection.outlook.com");

  if (!isTeamsSafelink && !isOutlookSafelink) return null;

  const target = url.searchParams.get("url");
  if (!target) return null;

  try {
    return new URL(target);
  } catch {
    return null;
  }
}

/**
 * @param {URL} url
 */
function accentureSafelink(url) {
  const inner = unwrapSafelink(url);
  return inner != null && matchesHost(inner, accentureHosts) ? inner : null;
}

/** @type {FinickyConfig} */
export default {
  defaultBrowser: "Zen",
  rewrite: [
    {
      // Replace only Safe Links whose hidden target is an Accenture host.
      match: (url) => accentureSafelink(url) != null,
      url: (url) => accentureSafelink(url) ?? url,
    },
  ],
  handlers: [
    {
      match: (url) => matchesHost(url, accentureHosts),
      browser: "Google Chrome",
    },
  ],
};
