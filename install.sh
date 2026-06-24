#!/usr/bin/env sh
# Aether Desktop installer.
#
# Downloads the latest arm64 DMG from GitHub Releases and installs it.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/d-ufrik/aether-desktop/main/install.sh | sh
#   curl -fsSL https://aether-models.ufrik.com/desktop/macos/install.sh | sh

set -eu

GITHUB_REPO="d-ufrik/aether-desktop"
APP_NAME="Aether"
APP_PATH="/Applications/${APP_NAME}.app"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/aether-install.XXXXXX")"
MOUNT_DIR="$TMP_DIR/mount"
DMG="$HOME/Downloads/Aether-latest-arm64.dmg"

cleanup() {
  if mount | grep -q "$MOUNT_DIR" 2>/dev/null; then
    hdiutil detach "$MOUNT_DIR" >/dev/null 2>&1 || true
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

mkdir -p "$HOME/Downloads" "$MOUNT_DIR"

say "fetching latest release info from GitHub"
RELEASE_JSON="$TMP_DIR/release.json"
curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" -o "$RELEASE_JSON"

VERSION="$(sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' "$RELEASE_JSON" | head -n 1)"
URL="$(sed -n 's/.*"browser_download_url": *"\([^"]*arm64\.dmg\)".*/\1/p' "$RELEASE_JSON" | head -n 1)"

if [ -z "$URL" ]; then
  printf '%s\n' "aether-install: could not find arm64 DMG in latest release" >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

say "downloading Aether Desktop $VERSION"
curl -fL "$URL" -o "$DMG"

say "mounting DMG"
hdiutil attach "$DMG" -nobrowse -readonly -mountpoint "$MOUNT_DIR" >/dev/null

if [ ! -d "$MOUNT_DIR/$APP_NAME.app" ]; then
  printf '%s\n' "aether-install: $APP_NAME.app not found in mounted DMG" >&2
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
