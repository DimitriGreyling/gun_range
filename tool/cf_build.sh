#!/usr/bin/env bash
set -euo pipefail

# Pin Flutter so builds are reproducible.
# Make sure this Flutter version contains Dart >= 3.5.3 (your pubspec SDK constraint).
FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.5}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="${ROOT_DIR}/.flutter"

echo "Using Flutter ${FLUTTER_VERSION} (${FLUTTER_CHANNEL})"
cd "${ROOT_DIR}"

if [ ! -d "${FLUTTER_DIR}" ]; then
  echo "Downloading Flutter SDK..."
  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${ARCHIVE}"

  curl -fsSL "${URL}" -o "${ARCHIVE}"
  mkdir -p "${FLUTTER_DIR}"
  tar xf "${ARCHIVE}"
  rm -f "${ARCHIVE}"

  # The archive extracts into ./flutter
  mv "${ROOT_DIR}/flutter" "${FLUTTER_DIR}"
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"

flutter --version
flutter config --enable-web > /dev/null

echo "Fetching dependencies..."
flutter pub get

echo "Building web..."
flutter build web --release --web-renderer canvaskit

echo "Build complete: ${ROOT_DIR}/build/web"