#!/bin/bash
#
# Builds the static production site (served from the `prod` branch by Cloudflare
# Pages) by running the Rails app locally and mirroring it with wget.
#
#   ./deploy_github.sh                 # build into ./dist
#   OUT_DIR=/tmp/site PORT=4100 ./deploy_github.sh
#
# The contents of $OUT_DIR are what get committed to the root of `prod`.
set -euo pipefail

cd "$(dirname "$0")"

PORT="${PORT:-3000}"
OUT_DIR="${OUT_DIR:-dist}"
HOST="127.0.0.1"
URL="http://${HOST}:${PORT}/"
BOOT_TIMEOUT="${BOOT_TIMEOUT:-60}"
PID_FILE="tmp/pids/static_build.pid"

# Files in public/ that wget can't discover by following links (all optional).
# No CNAME: that file is for GitHub Pages; Cloudflare Pages sets the domain itself.
EXTRAS=(public/thumbnail.png public/robots.txt public/sitemap.xml public/_headers)

RAILS_PID=""
cleanup() {
  if [[ -n "$RAILS_PID" ]] && kill -0 "$RAILS_PID" 2>/dev/null; then
    echo "Shutting down server (PID: $RAILS_PID)..."
    kill "$RAILS_PID" 2>/dev/null || true
    wait "$RAILS_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

if curl -s -o /dev/null "$URL"; then
  echo "Error: something is already listening on port ${PORT}. Stop it or set PORT=..." >&2
  exit 1
fi

# STATIC_BUILD turns off the development-only view annotations (HTML comments
# with template paths) so they don't end up in the published pages.
echo "Starting Rails server on ${URL} ..."
mkdir -p tmp/pids
rm -f "$PID_FILE"
STATIC_BUILD=1 bin/rails server -b "$HOST" -p "$PORT" -P "$PID_FILE" >log/static_build.log 2>&1 &
RAILS_PID=$!

echo "Waiting for server (up to ${BOOT_TIMEOUT}s)..."
for ((i = 0; i < BOOT_TIMEOUT; i++)); do
  if ! kill -0 "$RAILS_PID" 2>/dev/null; then
    echo "Error: Rails server exited during boot. See log/static_build.log" >&2
    exit 1
  fi
  if [[ "$(curl -s -o /dev/null -w '%{http_code}' "$URL")" == "200" ]]; then
    break
  fi
  sleep 1
done
if [[ "$(curl -s -o /dev/null -w '%{http_code}' "$URL")" != "200" ]]; then
  echo "Error: server did not answer 200 on ${URL} within ${BOOT_TIMEOUT}s" >&2
  exit 1
fi

echo "Mirroring site into ${OUT_DIR}/ ..."
# OUT_DIR is wiped before every build, so refuse anything that isn't a
# dedicated output directory.
case "$(cd "$(dirname "$OUT_DIR")" 2>/dev/null && pwd)/$(basename "$OUT_DIR")" in
  "/" | "$HOME" | "$PWD" | "$PWD/." | "$PWD/..") echo "Error: refusing to use OUT_DIR=${OUT_DIR}" >&2; exit 1 ;;
esac
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
# Exit code 8 means some link returned an HTTP error (e.g. a 404); report it
# but keep going. Anything else is a real failure.
set +e
wget --recursive --level=inf --convert-links --adjust-extension --page-requisites \
  --no-host-directories --no-verbose --directory-prefix="$OUT_DIR" "$URL"
WGET_STATUS=$?
set -e
if [[ $WGET_STATUS -eq 8 ]]; then
  echo "Warning: wget hit HTTP errors on some URLs (see output above)." >&2
elif [[ $WGET_STATUS -ne 0 ]]; then
  echo "Error: wget failed with exit code ${WGET_STATUS}" >&2
  exit 1
fi

for page in index.html process/index.html founder_letter/index.html; do
  if [[ ! -s "$OUT_DIR/$page" ]]; then
    echo "Error: expected page $OUT_DIR/$page is missing" >&2
    exit 1
  fi
done

# Without 404.html Cloudflare Pages serves index.html with a 200 for every
# unknown URL. The page is rendered by the app (errors#not_found) so it matches
# the rest of the site; its links are root-relative, so it works at any depth.
echo "Saving 404 page..."
if [[ "$(curl -s -o "$OUT_DIR/404.html" -w '%{http_code}' "${URL}not_found")" != "404" ]]; then
  echo "Error: ${URL}not_found did not render the not found page" >&2
  exit 1
fi

echo "Copying extra files..."
for file in "${EXTRAS[@]}"; do
  if [[ -f "$file" ]]; then
    cp "$file" "$OUT_DIR/"
    echo "  copied $file"
  else
    echo "  skipped $file (not found)"
  fi
done

echo "Done! Static site is in ${OUT_DIR}/ ($(du -sh "$OUT_DIR" | cut -f1))"
