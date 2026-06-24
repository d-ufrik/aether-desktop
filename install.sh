#!/usr/bin/env sh
# Aether Desktop YOLO installer.
#
# Usage:
#   curl -fsSL https://aether-models.ufrik.com/desktop/macos/install.sh | sh
#
# Installs the latest arm64 Aether Desktop DMG published in latest.xml.

set -eu

BASE_URL="${AETHER_DESKTOP_BASE_URL:-https://aether-models.ufrik.com/desktop/macos}"
APP_NAME="Aether"
APP_PATH="/Applications/${APP_NAME}.app"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/aether-install.XXXXXX")"
MOUNT_DIR="$TMP_DIR/mount"
META="$TMP_DIR/latest.xml"
DMG="$HOME/Downloads/Aether-latest-arm64.dmg"

cleanup() {
  if mount | grep -q "$MOUNT_DIR"; then
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
need shasum
need sed

mkdir -p "$HOME/Downloads" "$MOUNT_DIR"

say "fetching latest metadata"
curl -fsSL "$BASE_URL/latest.xml" -o "$META"

VERSION="$(sed -n 's:.*<version>\(.*\)</version>.*:\1:p' "$META" | head -n 1)"
SHA256="$(sed -n 's:.*<sha256>\(.*\)</sha256>.*:\1:p' "$META" | head -n 1)"
URL="$(sed -n 's:.*<latest>\(.*\)</latest>.*:\1:p' "$META" | head -n 1)"

if [ -z "$URL" ]; then
  URL="$BASE_URL/arm64/latest/Aether-latest-arm64.dmg"
fi

if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

say "downloading Aether Desktop $VERSION"
curl -fL "$URL" -o "$DMG"

if [ -n "$SHA256" ]; then
  GOT="$(shasum -a 256 "$DMG" | awk '{print $1}')"
  if [ "$GOT" != "$SHA256" ]; then
    printf '%s\n' "aether-install: checksum mismatch for $DMG" >&2
    printf '%s\n' "aether-install: expected $SHA256" >&2
    printf '%s\n' "aether-install: got      $GOT" >&2
    exit 1
  fi
  say "checksum verified"
fi

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
