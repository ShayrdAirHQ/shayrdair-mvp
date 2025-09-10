#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/webflow-export.sh                # auto-picks newest ~/Downloads/*.zip
#   scripts/webflow-export.sh /path/to.zip   # explicit path

ZIP_PATH="${1:-}"

# If no arg, pick newest .zip in ~/Downloads
if [ -z "${ZIP_PATH}" ]; then
  LATEST="$(ls -t "$HOME"/Downloads/*.zip 2>/dev/null | head -n 1 || true)"
  if [ -z "${LATEST}" ]; then
    echo "Error: No .zip files found in ~/Downloads."
    echo "Tip: Export from Webflow or provide a path: scripts/webflow-export.sh /path/to/export.zip"
    exit 1
  fi
  ZIP_PATH="${LATEST}"
fi

if [ ! -f "${ZIP_PATH}" ]; then
  echo "Error: ZIP not found: ${ZIP_PATH}"
  exit 1
fi

BRANCH="chore/webflow-export-$(date -u +%Y%m%d)"
git checkout -b "${BRANCH}"

TMPDIR="$(mktemp -d)"
unzip -q "${ZIP_PATH}" -d "${TMPDIR}"

mkdir -p apps/webflow-export
rsync -a --delete "${TMPDIR}/" apps/webflow-export/
rm -rf "${TMPDIR}"

npm run prettier-webflow || npx prettier --write 'apps/webflow-export/**/*.{html,css,js}'

git add apps/webflow-export
git commit -m "chore(webflow): export $(date +%F)"
git push -u origin "${BRANCH}"

if command -v gh >/dev/null 2>&1; then
  gh pr create --fill --title "chore(webflow): export $(date +%F)"
else
  echo "Branch pushed: ${BRANCH}"
  echo "Open a PR in GitHub."
fi
