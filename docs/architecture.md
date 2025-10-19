# ShayrdAir MVP — Architecture Overview

## Stack Summary
- Frontend: Webflow (exported) + Wized (logic)
- Backend: Supabase (Postgres + RLS + Triggers)
- Payments: Stripe (Checkout + Webhooks)
- Hosting: Vercel Pro linked to GitHub
- Automation: Make / n8n / Supabase Functions (optional)

## Core Data Model
users → guides → experiences → pricing_tiers → bookings → reviews → messages  
(Refer to `db/schema/SCHEMA.md` for details.)

## MVP Goals
- Launch public beta with dynamic group pricing and Stripe Checkout.  
- Collect feedback on UX and pricing elasticity.

## Design Philosophy
Asset-light and AI-native — lean backend logic and repeatable patterns for AI agents to extend.

## Environment Layout
- Dev: Supabase (dev) + Vercel preview deploys (per branch)
- Prod: Supabase (prod) + Vercel main
- Branch Protection: main locked; feature branches via PRs

## Future Integration
- Internal API gateway for guide availability and dynamic pricing logic.  
- AI-powered concierge for recommendations and pricing insights.

*(Last updated via Claude Migration Block 2.)*
