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

  rm -rf "${FLUTTER_DIR}" "${ROOT_DIR}/flutter"

  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${ARCHIVE}"

  curl -fsSL "${URL}" -o "${ARCHIVE}"

  # This extracts a top-level ./flutter directory
  tar xf "${ARCHIVE}" -C "${ROOT_DIR}"
  rm -f "${ARCHIVE}"

  # Move extracted SDK into .flutter
  mv "${ROOT_DIR}/flutter" "${FLUTTER_DIR}"
fi

echo "Flutter bin is at: ${FLUTTER_DIR}/bin/flutter"
ls -la "${FLUTTER_DIR}/bin/flutter"

export PATH="${FLUTTER_DIR}/bin:${PATH}"

# Call flutter via absolute path once, to prove it exists
"${FLUTTER_DIR}/bin/flutter" --version

echo "Fetching dependencies..."
flutter pub get

echo "Building web..."
flutter build web --release --web-renderer canvaskit

echo "Build complete: ${ROOT_DIR}/build/web"
ls -la "${ROOT_DIR}/build/web" | head -n 50