#!/usr/bin/env bash
set -euo pipefail

# Enable verbose logs in Cloudflare by setting DEBUG=1 in Pages env vars
if [ "${DEBUG:-}" = "1" ]; then
  set -x
fi

FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.5}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="${ROOT_DIR}/.flutter"

cd "${ROOT_DIR}"

echo "Using Flutter ${FLUTTER_VERSION} (${FLUTTER_CHANNEL})"
echo "Repo: ${ROOT_DIR}"
ls -la

# Download Flutter SDK (Linux) into .flutter/
if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  echo "Downloading Flutter SDK..."

  rm -rf "${FLUTTER_DIR}" "${ROOT_DIR}/flutter"

  ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${ARCHIVE}"

  curl -fsSL "${URL}" -o "${ARCHIVE}"
  tar xf "${ARCHIVE}" -C "${ROOT_DIR}"
  rm -f "${ARCHIVE}"

  mv "${ROOT_DIR}/flutter" "${FLUTTER_DIR}"
fi

FLUTTER_BIN="${FLUTTER_DIR}/bin/flutter"

echo "Flutter at: ${FLUTTER_BIN}"
"${FLUTTER_BIN}" --version

# Reduce noise in Cloudflare logs
"${FLUTTER_BIN}" config --no-analytics --no-cli-animations > /dev/null || true
"${FLUTTER_BIN}" config --enable-web > /dev/null || true

# ---- .env handling ----
# Cloudflare Pages MUST provide these env vars, unless you commit .env to the repo.
supabase_url="${SUPABASE_URL-}"
supabase_anon="${SUPABASE_ANON_KEY-}"

echo "SUPABASE_URL present? $([ -n "${supabase_url}" ] && echo yes || echo no)"
echo "SUPABASE_ANON_KEY present? $([ -n "${supabase_anon}" ] && echo yes || echo no)"
echo "SUPABASE_ANON_KEY length: ${#supabase_anon}"

if [ -n "${supabase_url}" ] && [ -n "${supabase_anon}" ]; then
  echo "Generating .env from Cloudflare environment variables..."
  cat > "${ROOT_DIR}/.env" <<EOF
SUPABASE_URL=${supabase_url}
SUPABASE_ANON_KEY=${supabase_anon}
EOF
else
  # If you choose to commit .env (public values for web), this will allow builds to proceed.
  if [ -f "${ROOT_DIR}/.env" ]; then
    echo "Using existing .env from repo."
  else
    echo "ERROR: Missing SUPABASE_URL / SUPABASE_ANON_KEY in Cloudflare Pages build environment."
    echo "Fix: Cloudflare Pages Project -> Settings -> Environment variables"
    echo "Add BOTH variables in the correct environment (Production/Preview) and redeploy."
    exit 1
  fi
fi

# Build
"${FLUTTER_BIN}" pub get
"${FLUTTER_BIN}" build web --release --web-renderer canvaskit

echo "Build complete. Output:"
ls -la "${ROOT_DIR}/build/web" | head -n 60