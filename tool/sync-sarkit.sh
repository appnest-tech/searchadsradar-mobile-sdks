#!/usr/bin/env bash
# Syncs the pinned SARKit tag into vendor/ and fans out into packages.
# SARKit is two SwiftPM modules; packages compile it as ONE module, so the
# cross-module import lines are stripped (deterministic patch). Never edit
# the outputs by hand — CI re-runs this script and fails on any diff.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TAG="$(tr -d '[:space:]' < "$ROOT/SARKIT_VERSION")"
UPSTREAM="https://github.com/appnest-tech/searchadsradar-ios-sdk"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Syncing SARKit $TAG from $UPSTREAM"
git clone --quiet --depth 1 --branch "$TAG" "$UPSTREAM" "$TMP/upstream"

VENDOR="$ROOT/vendor/sarkit"
rm -rf "$VENDOR" && mkdir -p "$VENDOR"

# Flatten both modules, stripping cross-module imports.
find "$TMP/upstream/Sources/SARKitCore" "$TMP/upstream/Sources/SARKit" \
    -name '*.swift' -print0 | while IFS= read -r -d '' src; do
  base="$(basename "$src")"
  if [ -e "$VENDOR/$base" ]; then
    echo "ERROR: duplicate filename '$base' across SARKit modules" >&2
    exit 1
  fi
  sed -e '/^import SARKitCore$/d' \
      -e '/^@_exported import SARKitCore$/d' "$src" > "$VENDOR/$base"
done

cp "$TMP/upstream/Sources/SARKitCore/PrivacyInfo.xcprivacy" "$VENDOR/"
printf '%s\n' "$TAG" > "$VENDOR/.sarkit-tag"

# Fan out: Flutter package.
FLUTTER_SRC="$ROOT/packages/flutter/ios/searchadsradar/Sources/searchadsradar"
rm -rf "$FLUTTER_SRC/vendored" && mkdir -p "$FLUTTER_SRC/vendored"
cp "$VENDOR"/*.swift "$FLUTTER_SRC/vendored/"
cp "$VENDOR/PrivacyInfo.xcprivacy" "$FLUTTER_SRC/PrivacyInfo.xcprivacy"

echo "OK: vendored SARKit $TAG ($(ls "$VENDOR"/*.swift | wc -l | tr -d ' ') files)"
