# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

ShayrdAir is an outdoor adventure marketplace MVP connecting guides with customers. The stack is asset-light and AI-native, designed for rapid iteration with minimal backend logic.

**Stack:**
- Frontend: Webflow (exported HTML/CSS) + Wized (client-side logic)
- Backend: Supabase (Postgres + RLS + Triggers)
- Payments: Stripe (Checkout + Webhooks)
- Hosting: Vercel Pro (linked to GitHub)
- Automation: Make / n8n / Supabase Functions (optional)

**Branch Strategy:**
- Main branch: `main` (protected, deployment target)
- Feature branches via PRs only
- Naming: kebab-case (e.g., `feature/dynamic-pricing`)

## Development Commands

### Linting & Formatting
```bash
# Lint HTML files from Webflow export
npm run lint:html

# Lint CSS files
npm run lint:css

# Format all files (HTML, CSS, JS, JSON, MD, YAML)
npm run format

# Format Webflow export files only
npm run prettier-webflow
```

### Webflow Export Workflow
```bash
# Export from Webflow and create PR automatically
# Uses latest .zip from ~/Downloads or provide path
./scripts/webflow-export.sh [/path/to/export.zip]

# Process: creates branch → formats → commits → pushes → opens PR
```

### Utilities
```bash
# Run stylesmith tool (CSS analysis/transformation)
npm run stylesmith

# Generate GPT coaching reports on CSS changes
npm run gpt:coach
```

## Architecture & Data Model

### Core Entity Relationships
```
users → guides → experiences → pricing_tiers → bookings → reviews
                             ↘ availabilities
users → conversations → messages
```

### Key Tables (see db/schema/SCHEMA.md for full reference)
- **users**: Base auth identity (email, role: admin|guide|customer)
- **guides**: Guide profiles linked to users
- **experiences**: Trip listings with location, difficulty, pricing
- **pricing_tiers**: Dynamic group pricing (party_size → price_per_person)
- **bookings**: Reservations with Stripe payment tracking
- **conversations/messages**: Customer-guide messaging
- **availabilities**: Guide scheduling (time slots + capacity)

### Database Conventions
- Write reversible SQL migrations
- Use RLS (Row-Level Security) for access control
- Describe schema impact before implementing changes
- Prefer triggers for complex business logic

## File Structure

```
apps/webflow-export/     # Exported Webflow frontend (HTML/CSS/JS)
db/schema/               # Database schema documentation
docs/                    # Architecture docs and ADRs
  architecture.md        # High-level stack overview
  decisions/ADR-*.md     # Architectural Decision Records
ai/                      # AI assistant context files
  system/                # Claude project instructions
  context/               # Project summary for AI
  prompts/               # Task-specific prompt library
scripts/
  webflow-export.sh      # Automated Webflow export workflow
  export-context.sh      # Export project context for AI
  redact.sh              # Sanitize sensitive data
tools/stylesmith/        # CSS analysis tool
exports/                 # Generated snapshots and exports
reports/                 # Analysis reports
```

## Important Documentation

**Start here when orienting to the project:**
1. `ai/context/context-summary.md` - One-page project overview
2. `docs/architecture.md` - Stack and environment layout
3. `db/schema/SCHEMA.md` - Database schema reference
4. `ai/prompts/INDEX.md` - Task-specific prompt templates

**Workflow guides:**
- `WEBFLOW_EXPORT_PLAYBOOK.md` - Exporting and deploying Webflow changes
- `docs/decisions/ADR-0001.md` - Tech stack rationale

## Development Principles

**From ai/system/claude-project-instructions.md:**

- **Correctness over cleverness**: Propose minimal, reproducible steps
- **Respect the stack**: Don't suggest framework migrations unless explicitly requested
- **CLI-first**: Provide copy-ready code blocks with proper fencing
- **Privacy**: Never request, invent, or store secrets; assume runtime env via Vercel/Supabase
- **Output style**:
  - Plans: Linear checklists with acceptance criteria
  - Code: Minimal, runnable, idempotent
  - Reviews: Cite exact file paths and line numbers
- **Naming conventions**:
  - Branches: kebab-case
  - ADRs: `ADR-####.md` format
- **When unsure**: State assumptions, propose 2-3 options with tradeoffs, ask for minimal confirmation

## Webflow Integration

Webflow exports live in `apps/webflow-export/` and are version-controlled. The workflow is:

1. Design/build in Webflow
2. Export as .zip
3. Run `./scripts/webflow-export.sh` (auto-creates branch + PR)
4. GitHub Actions run lint checks + Vercel preview deploy
5. Review PR diffs and preview URL
6. Squash and merge to deploy to main

**Do not** suggest migrating to React/Next.js unless explicitly requested. The Webflow + Wized approach is intentional for rapid iteration.

## Environment & Deployment

- **Dev**: Supabase dev project + Vercel preview deploys (per branch)
- **Prod**: Supabase prod project + Vercel main branch
- Branch protection on `main` - all changes via PRs
- Vercel automatically deploys previews for PRs

## Testing & Quality

Currently using:
- `html-validate` for HTML linting
- `stylelint` for CSS linting
- `prettier` for code formatting
- GitHub Actions for CI checks on PRs

No formal test suite yet - this is an MVP focused on rapid validation.
