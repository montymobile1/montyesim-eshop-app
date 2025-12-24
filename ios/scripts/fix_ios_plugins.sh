#!/bin/bash
# Fixes for iOS-related Flutter plugins that may break CI/local builds.
#
# Currently patches:
# - flutter_vibrate (Swift 6 / Xcode 16+): replace TARGET_OS_SIMULATOR checks with targetEnvironment(simulator)
# - chucker_flutter: fix http_logging_interceptor.dart (requestBase.body/bodyBytes requires cast)
#
# This script patches in two common locations:
# - iOS CocoaPods (ios/Pods) after `pod install` (for flutter_vibrate Swift files)
# - Flutter pub cache (~/.pub-cache) which is what `flutter build` compiles from

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$(dirname "$SCRIPT_DIR")"
PODS_DIR="$IOS_DIR/Pods"

HOME_DIR_INPUT="${1:-}"
HOME_DIR="${HOME_DIR_INPUT:-${HOME_Directory:-${HOME:-}}}"
PUB_CACHE_DIR="${HOME_DIR}/.pub-cache"
PUB_HOSTED_DIR="${PUB_CACHE_DIR}/hosted/pub.dev"

echo "🔧 Patching iOS Flutter plugins for CI/local compatibility..."
echo "📌 Home dir: ${HOME_DIR:-<unknown>}"

sed_inplace() {
  # macOS BSD sed requires: sed -i '' ...
  # GNU sed accepts: sed -i ...
  local expr="$1"
  local file="$2"
  if sed --version >/dev/null 2>&1; then
    sed -i -e "$expr" "$file"
  else
    sed -i '' -e "$expr" "$file"
  fi
}

patch_flutter_vibrate_swift() {
  local file="$1"
  [ -f "$file" ] || return 0

  if ! grep -q "TARGET_OS_SIMULATOR" "$file"; then
    return 0
  fi

  echo "📄 Patching flutter_vibrate: $file"

  # 1) Replace macro-style Swift checks (Swift 6 rejects TARGET_OS_SIMULATOR)
  if grep -q "#if[[:space:]]*!*[[:space:]]*TARGET_OS_SIMULATOR" "$file"; then
    cp "$file" "$file.bak"
    sed_inplace 's/#if[[:space:]]\+TARGET_OS_SIMULATOR/#if targetEnvironment(simulator)/g' "$file"
    sed_inplace 's/#if[[:space:]]\+![[:space:]]*TARGET_OS_SIMULATOR/#if !targetEnvironment(simulator)/g' "$file"
    rm -f "$file.bak"
  fi

  # 2) Replace the older single-line constant with a closure-based device check
  if grep -q "private let isDevice = TARGET_OS_SIMULATOR == 0" "$file"; then
    cp "$file" "$file.bak"
    perl -0777 -i -pe 's/private let isDevice = TARGET_OS_SIMULATOR == 0/private let isDevice = {\n  #if targetEnvironment(simulator)\n      return false\n  #else\n      return true\n  #endif\n}()/g' "$file"
    rm -f "$file.bak"
  fi
}

patch_chucker_flutter_dart() {
  local file="$1"
  [ -f "$file" ] || return 0

  # Only patch if we see the old patterns.
  if ! grep -q "final body = requestBase.body;" "$file" && ! grep -q "requestBase\.bodyBytes\.length" "$file"; then
    return 0
  fi

  echo "📄 Patching chucker_flutter: $file"
  cp "$file" "$file.bak"

  # 1) requestBase.body -> cast to http.Request
  sed_inplace 's/final body = requestBase\.body;/final body = (requestBase as http.Request)\.body;/g' "$file"

  # 2) requestBase.bodyBytes.length -> cast to http.Request
  # Avoid double-wrapping if it was already patched.
  if ! grep -q "(requestBase as http.Request)\.bodyBytes\.length" "$file"; then
    sed_inplace 's/requestBase\.bodyBytes\.length/(requestBase as http.Request)\.bodyBytes\.length/g' "$file"
  fi

  rm -f "$file.bak"
}

# --- Patch Pods (if present): flutter_vibrate ---
if [ -d "$PODS_DIR" ]; then
  while IFS= read -r f; do
    patch_flutter_vibrate_swift "$f"
  done < <(find "$PODS_DIR" -name "SwiftVibratePlugin.swift" 2>/dev/null)
fi

# --- Patch pub cache (preferred; matches Flutter build inputs) ---
if [ -n "${HOME_DIR:-}" ] && [ -d "$PUB_HOSTED_DIR" ]; then
  echo "🔎 Searching pub cache for flutter_vibrate SwiftVibratePlugin.swift..."
  while IFS= read -r f; do
    patch_flutter_vibrate_swift "$f"
  done < <(find "$PUB_HOSTED_DIR" -path "*/flutter_vibrate-*/ios/Classes/SwiftVibratePlugin.swift" 2>/dev/null)

  echo "🔎 Searching pub cache for chucker_flutter http_logging_interceptor.dart..."
  while IFS= read -r f; do
    patch_chucker_flutter_dart "$f"
  done < <(find "$PUB_HOSTED_DIR" -path "*/chucker_flutter-*/lib/src/interceptors/http_logging_interceptor.dart" 2>/dev/null)
else
  echo "ℹ️  Pub cache directory not found at: $PUB_HOSTED_DIR (skipping pub-cache patches)"
fi

echo "✅ iOS plugin patching complete"


