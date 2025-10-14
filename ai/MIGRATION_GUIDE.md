# ShayrdAir — GPT → Claude Pro Migration Guide

## Purpose
Enable a safe, repeatable export of the minimal, most useful project context for Claude Pro.

## What to Upload to Claude
1. `ai/system/claude-project-instructions.md` (pin)
2. `ai/context/context-summary.md` (pin)
3. `docs/architecture.md` (pin)
4. `db/schema/SCHEMA.md` (or `SCHEMA.sanitized.md`) (pin)
5. Top prompts in `ai/prompts/` (pin 3–5 most-used)
6. Optional: `apps/webflow-export/` HTML/CSS snapshot

## How to Generate a Context Pack
./scripts/export-context.sh

## Privacy
- Never upload `.env*`, API keys, or raw secrets.
- Use `scripts/redact.sh` before sharing logs or configs.

## Refresh Cadence
- Re-export after schema changes or major PR merges.
- Keep `ai/context/context-summary.md` fresh (≤ 1 page).

## Verification
After upload, ask Claude:
- "Summarize `ai/context/context-summary.md` in 5 bullets."
- "List the key tables and FKs relevant to dynamic group pricing."
- "Draft a 7-day MVP plan referencing pinned files."

If responses are off, update the Context Pack and re-upload.
