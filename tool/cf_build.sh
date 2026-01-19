#!/usr/bin/env bash
set -euo pipefail
set -x

FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.5}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="${ROOT_DIR}/.flutter"

cd "${ROOT_DIR}"
echo "Using Flutter ${FLUTTER_VERSION} (${FLUTTER_CHANNEL})"
pwd
ls -la

if [ ! -d "${FLUTTER_DIR}" ]; then
  echo "Downloading Flutter SDK..."
  rm -rf "${ROOT_DIR}/flutter"

  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${ARCHIVE}"

  curl -fsSL "${URL}" -o "${ARCHIVE}"
  tar xf "${ARCHIVE}" -C "${ROOT_DIR}"
  rm -f "${ARCHIVE}"

  mv "${ROOT_DIR}/flutter" "${FLUTTER_DIR}"
fi

# Find flutter binary robustly (handles nested layouts)
FLUTTER_BIN=""
if [ -x "${FLUTTER_DIR}/bin/flutter" ]; then
  FLUTTER_BIN="${FLUTTER_DIR}/bin/flutter"
elif [ -x "${FLUTTER_DIR}/flutter/bin/flutter" ]; then
  FLUTTER_BIN="${FLUTTER_DIR}/flutter/bin/flutter"
fi

if [ -z "${FLUTTER_BIN}" ]; then
  echo "ERROR: Flutter binary not found under ${FLUTTER_DIR}"
  find "${FLUTTER_DIR}" -maxdepth 4 -type f -name flutter -print || true
  exit 1
fi

"${FLUTTER_BIN}" --version
"${FLUTTER_BIN}" config --enable-web

# Create .env (required because pubspec.yaml bundles it as an asset)
: "${SUPABASE_URL:?Set SUPABASE_URL in Cloudflare Pages environment variables}"
: "${SUPABASE_ANON_KEY:?Set SUPABASE_ANON_KEY in Cloudflare Pages environment variables}"

cat > "${ROOT_DIR}/.env" <<EOF
SUPABASE_URL=${SUPABASE_URL}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
EOF

"${FLUTTER_BIN}" pub get
"${FLUTTER_BIN}" build web --release --web-renderer canvaskit

ls -la "${ROOT_DIR}/build/web" | head -n 50