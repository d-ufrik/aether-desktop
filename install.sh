#!/usr/bin/env sh
# Aether Desktop installer.
#
# Resolves the latest arm64 DMG from the R2 subdomain (aether-models.ufrik.com)
# first, falling back to GitHub Releases if the subdomain is unreachable, then
# installs it. Same subdomain-first chain the app uses for the model catalog.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/d-ufrik/aether-desktop/main/install.sh | sh
#   curl -fsSL https://aether-models.ufrik.com/desktop/macos/install.sh | sh

set -eu

GITHUB_REPO="d-ufrik/aether-desktop"
# Primary source of truth for "what is the latest DMG": the R2 subdomain
# metadata, same host the app uses for the model catalog. GitHub Releases is
# only the fallback — its /releases/latest pointer ranks by tag-commit date,
# not version, so it can go stale (incident 2026-06-25). Subdomain first.
LATEST_XML_URL="https://aether-models.ufrik.com/desktop/macos/latest.xml"
APP_NAME="Aether"
APP_PATH="/Applications/${APP_NAME}.app"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/aether-install.XXXXXX")"
DMG="$TMP_DIR/Aether-latest-arm64.dmg"
MOUNT_DIR=""

cleanup() {
  if [ -n "$MOUNT_DIR" ]; then
    hdiutil detach "$MOUNT_DIR" -force >/dev/null 2>&1 || true
  fi
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

say() {
  printf '%s\n' "aether-install: $*"
}

need() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '%s\n' "aether-install: missing required command: $1" >&2
    exit 1
  }
}

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' "aether-install: Aether Desktop installer requires macOS" >&2
  exit 1
fi

if [ "$(uname -m)" != "arm64" ]; then
  printf '%s\n' "aether-install: Aether Desktop local inference builds currently require Apple Silicon arm64" >&2
  exit 1
fi

need curl
need hdiutil
need sed

mkdir -p "$HOME/Downloads"

VERSION=""
URL=""

# 1) Primary: R2 subdomain latest.xml (authoritative, set by publish-update.sh).
say "checking latest version (aether-models.ufrik.com)"
LATEST_XML="$TMP_DIR/latest.xml"
if curl -fsSL "$LATEST_XML_URL" -o "$LATEST_XML" 2>/dev/null; then
  VERSION="$(sed -n 's:.*<version>\([^<]*\)</version>.*:\1:p' "$LATEST_XML" | head -n 1)"
  URL="$(sed -n 's:.*<dmg>\([^<]*\)</dmg>.*:\1:p' "$LATEST_XML" | head -n 1)"
fi

# 2) Fallback: GitHub Releases (only if the subdomain was unreachable / empty).
if [ -z "$URL" ]; then
  say "subdomain unavailable — falling back to GitHub Releases"
  RELEASE_JSON="$TMP_DIR/release.json"
  if curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" -o "$RELEASE_JSON" 2>/dev/null; then
    VERSION="$(sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' "$RELEASE_JSON" | head -n 1)"
    URL="$(sed -n 's/.*"browser_download_url": *"\([^"]*arm64\.dmg\)".*/\1/p' "$RELEASE_JSON" | head -n 1)"
  fi
fi

if [ -z "$URL" ]; then
  printf '%s\n' "aether-install: could not determine latest DMG from subdomain or GitHub" >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

say "downloading Aether Desktop $VERSION"
curl -fL "$URL" -o "$DMG"

say "mounting DMG"
MOUNT_DIR="$(hdiutil attach "$DMG" -nobrowse -readonly | awk -F'\t' '/\/Volumes\// {print $NF; exit}')"

if [ -z "$MOUNT_DIR" ]; then
  printf '%s\n' "aether-install: could not mount DMG" >&2
  exit 1
fi

if [ ! -d "$MOUNT_DIR/$APP_NAME.app" ]; then
  printf '%s\n' "aether-install: $APP_NAME.app not found in mounted DMG ($MOUNT_DIR)" >&2
  exit 1
fi

say "installing to $APP_PATH"
if [ -w "/Applications" ]; then
  rm -rf "$APP_PATH"
  cp -R "$MOUNT_DIR/$APP_NAME.app" "$APP_PATH"
else
  sudo rm -rf "$APP_PATH"
  sudo cp -R "$MOUNT_DIR/$APP_NAME.app" "$APP_PATH"
fi

say "launching Aether"
open -a "$APP_PATH"

say "done"
