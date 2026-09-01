#!/usr/bin/env bash
#
# One-click build + install for Safe's Playce — Livestream Android app.
#
# Usage:
#   ./build.sh                 # build debug APK, then install on a connected device/emulator
#   ./build.sh --no-install    # build the debug APK only
#   ./build.sh --release       # build the release APK (unsigned; needs signing config for Play)
#
set -euo pipefail

cd "$(dirname "$0")"

INSTALL=1
TASK=assembleDebug
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
for arg in "$@"; do
  case "$arg" in
    --no-install) INSTALL=0 ;;
    --release) TASK=assembleRelease; APK_PATH="app/build/outputs/apk/release/app-release-unsigned.apk" ;;
    -h|--help) sed -n '1,20p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

echo "==> Building: ./gradlew $TASK"
./gradlew "$TASK" --no-daemon

if [ ! -f "$APK_PATH" ]; then
  echo "ERROR: Expected APK not found: $APK_PATH" >&2
  exit 1
fi

echo "==> APK ready: $(pwd)/$APK_PATH"
echo "    File size: $(du -h "$APK_PATH" | cut -f1)"

if [ "$INSTALL" -eq 1 ]; then
  if ! command -v adb >/dev/null 2>&1; then
    echo ""
    echo "adb not found — skipping install. Install Android SDK platform-tools (adb),"
    echo "connect your phone with USB debugging on, then run:"
    echo "  adb install -r $APK_PATH"
    exit 0
  fi
  echo "==> Installing to device..."
  adb install -r "$APK_PATH"
fi

echo ""
echo "Done. To open on your phone: copy '$APK_PATH' to the phone and tap it,"
echo "or keep the phone connected and use: adb install -r $APK_PATH"
