# ShayrdAir — Context Summary (1-Pager)

## Thesis
Asset-light “Costco × Airbnb Experiences” for outdoor adventures. Dynamic group pricing lowers per-person cost as more people join a guided trip. MVP focuses on Colorado climbing/hiking experiences.

## Stack & Environments
- Frontend: Webflow export + Wized logic (apps/webflow-export/)
- Backend: Supabase (Postgres, RLS, triggers)
- Payments: Stripe (Checkout + Webhooks)
- Hosting: Vercel Pro (repo: shayrdair-mvp)
- Source: GitHub (protected `main`, feature branches → PR)
Secrets live in Vercel/Supabase; `.env*` never enters git.

## Key Data (high-level)
- `users` (id, email, role, phone_number)
- `guides` (user_id FK, bio, profile_image_url)
- `experiences` (guide_id FK, title, slug, location, duration, difficulty, season, media, status, SEO)
- `pricing_tiers` (experience_id FK, party_size, price_per_person, optional label)
- Planned/exists: `bookings`, `messages`, `conversations`, `reviews`, `availabilities`
Dynamic pricing: price-per-person determined by exact party size via `pricing_tiers`.

## Current Focus (next 7–14 days)
1) Finish Claude migration context + exporter.
2) Finalize `pricing_tiers` model and Wized bindings for exact party size.
3) Stripe Checkout path: experience → tier selection → checkout → webhook → booking record.
4) Minimal reviews + messages scaffolding.
Definition of done: one experience can be discovered, priced by size, and paid via Stripe; booking row created.

## Risks / Constraints
- Non-technical founder: require copy-ready commands and reversible changes.
- Webflow export diffs are noisy; prefer CSS/HTML-only snapshots in Context Pack.
- No secrets in AI context; keep zip < ~50MB.

## Conventions
- Linear-style tasks with acceptance criteria.
- ADRs for decisions (e.g., ADR-0001 Stack; next: ADR-0002 Dynamic Pricing; ADR-0003 Messaging).
- Use `scripts/export-context.sh` to build the Claude Context Pack.
