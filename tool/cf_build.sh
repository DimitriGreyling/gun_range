#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.5}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="${ROOT_DIR}/.flutter"

echo "Using Flutter ${FLUTTER_VERSION} (${FLUTTER_CHANNEL})"
cd "${ROOT_DIR}"

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  echo "Downloading Flutter SDK..."

  rm -rf "${FLUTTER_DIR}"
  mkdir -p "${FLUTTER_DIR}"

  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${ARCHIVE}"

  curl -fsSL "${URL}" -o "${ARCHIVE}"

  # Archive contains top-level "flutter/..." folder; strip it so bin/flutter lands in ${FLUTTER_DIR}/bin/flutter
  tar xf "${ARCHIVE}" -C "${FLUTTER_DIR}" --strip-components=1
  rm -f "${ARCHIVE}"
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"

flutter --version
flutter config --enable-web > /dev/null

echo "Fetching dependencies..."
flutter pub get

echo "Building web..."
flutter build web --release --web-renderer canvaskit

echo "Build complete: ${ROOT_DIR}/build/web"
ls -la "${ROOT_DIR}/build/web" | head -n 50