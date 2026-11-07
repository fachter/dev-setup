// @ts-check
// https://github.com/johnste/finicky/wiki/Configuration-(v4)

/**
 * @typedef {import("/Applications/Finicky.app/Contents/Resources/finicky.d.ts").FinickyConfig} FinickyConfig
 */

// Hosts that require an Accenture login. Add more as they show up.
const accentureHosts = ["accenture.com"];

const claudeLoginHosts = ["claude.ai", "platform.claude.com"];
const cursorLoginHosts = ["cursor.com", "cursor.sh"];

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
 * @param {string} pathname
 * @param {string} prefix
 */
function matchesPath(pathname, prefix) {
  return pathname === prefix || pathname.startsWith(`${prefix}/`);
}

/**
 * Accenture Workday, including the auth gateway under /wday/authgwy/accenture.
 * @param {URL} url
 */
function matchesWorkday(url) {
  if (url.hostname !== "wd103.myworkday.com") return false;
  return url.pathname.split("/").includes("accenture");
}

/**
 * Claude Code and claude.ai sign-in. The rest of the site stays in Zen.
 * @param {URL} url
 */
function matchesClaudeLogin(url) {
  if (!matchesHost(url, claudeLoginHosts)) return false;
  return (
    matchesPath(url.pathname, "/login") || matchesPath(url.pathname, "/oauth")
  );
}

/**
 * Cursor editor and CLI sign-in. The rest of the site stays in Zen.
 * @param {URL} url
 */
function matchesCursorLogin(url) {
  if (!matchesHost(url, cursorLoginHosts)) return false;
  return (
    matchesPath(url.pathname, "/loginDeepControl") ||
    matchesPath(url.pathname, "/login")
  );
}

/**
 * @param {URL} url
 */
function opensInChrome(url) {
  return (
    matchesHost(url, accentureHosts) ||
    matchesWorkday(url) ||
    matchesClaudeLogin(url) ||
    matchesCursorLogin(url)
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
function chromeSafelink(url) {
  const inner = unwrapSafelink(url);
  return inner != null && opensInChrome(inner) ? inner : null;
}

/** @type {FinickyConfig} */
export default {
  defaultBrowser: "Zen",
  rewrite: [
    {
      // Replace Safe Links whose hidden target should open in Chrome.
      match: (url) => chromeSafelink(url) != null,
      url: (url) => chromeSafelink(url) ?? url,
    },
  ],
  handlers: [
    {
      match: opensInChrome,
      browser: "Google Chrome",
    },
  ],
};
