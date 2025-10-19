#!/usr/bin/env bash
set -euo pipefail

OUTDIR="${1:-/tmp/shayrdair-context}"
STAMP="$(date +%Y%m%d)"
PKG="${OUTDIR}/shayrdair-context-${STAMP}.zip"

rm -rf "$OUTDIR"
mkdir -p "$OUTDIR/ai" "$OUTDIR/db" "$OUTDIR/docs" "$OUTDIR/apps"

cp -v README.md "$OUTDIR/" 2>/dev/null || true
cp -vr ai "$OUTDIR/" 2>/dev/null || true
cp -vr docs "$OUTDIR/" 2>/dev/null || true

mkdir -p "$OUTDIR/db/schema" "$OUTDIR/db/migrations"
cp -vr db/schema "$OUTDIR/db/" 2>/dev/null || true
cp -vr db/migrations "$OUTDIR/db/" 2>/dev/null || true

mkdir -p "$OUTDIR/apps/webflow-export"
rsync -av --include '*/' --include '*.html' --include '*.css' --exclude '*' apps/webflow-export/ "$OUTDIR/apps/webflow-export/" 2>/dev/null || true

cat > "$OUTDIR/INDEX.md" <<'MD'
# ShayrdAir — Context Index
- README.md
- docs/ (architecture, decisions, workflows)
- ai/ (system instructions, context, prompts)
- db/schema/ (reference)
- db/migrations/ (structure)
- apps/webflow-export/ (HTML/CSS snapshot)
Start with: ai/system/claude-project-instructions.md → ai/context/context-summary.md → docs/architecture.md.
MD

( cd "$OUTDIR" && zip -r "$PKG" . >/dev/null )
echo "$PKG"
