# ShayrdAir — AI-Native Outdoor Marketplace

**Mission:** Make outdoor adventure more accessible and affordable through dynamic group pricing.

ShayrdAir is an asset-light "Costco × Airbnb Experiences" marketplace for outdoor adventures.  
Our MVP connects climbers with guides using a group-pricing model that lowers per-person cost as more people join.

---

## ⚙️ Tech Stack

- **Frontend:** Webflow export + Wized logic  
- **Backend:** Supabase (Postgres + RLS + Functions + Realtime Chat)  
- **Payments:** Stripe Checkout + Webhooks  
- **Hosting:** Vercel Pro (CI/CD via GitHub)  
- **AI Tools:** Claude Code (CLI), Claude Pro, GPT-5, Cursor  

---

## 🧱 Repo Structure

```
ai/                  → AI system instructions, prompts, and context
db/schema/           → Supabase schema docs (auto-generated)
docs/                → Architecture, ADRs, and workflows
scripts/             → Automation scripts (export-context, redact, schema sync)
apps/webflow-export/ → Webflow → Vercel static build
CLAUDE.md            → Repo map for Claude Code
```

---

## 🚀 Quick Start

Before starting, ensure you have **Node.js 18+**, **npm**, the **Vercel CLI**, and access to your **Supabase keys** installed and configured.

```bash
git clone https://github.com/ShayrdAirHQ/shayrdair-mvp.git
cd shayrdair-mvp
cp .env.example .env     # Fill in Supabase + Stripe keys
npm install
vercel dev
```

---

## 🧩 Use Claude Code Locally

After installing Node.js 18+, npm, and the Vercel CLI, you can interact with your local repo directly through Claude Code.

```bash
cd shayrdair-mvp
claude-code .
```

💡 **Tip:**  
When Claude Code launches, try prompts such as:
* "List the top-level folders in this repo."
* "Explain how db/schema/SCHEMA.md relates to the pricing_tiers table."

Claude reads directly from your local environment (CLAUDE.md, docs/, ai/, etc.) and reasons about them in context.

---

## 🧠 Developer Notes

* **Schema sync:** run `./scripts/update-schema-docs.sh` before committing DB changes.
* **Context export:** `./scripts/export-context.sh ~/Desktop/shayrdair-claude-context`
* **Claude Pro update:** upload the .md files from `/ai`, `/docs`, and `/db/schema`.
* **Secrets:** never commit `.env*`; environment variables live in Vercel + Supabase config.

---

## 🪜 Environment Overview

| Layer | Tool |
|-------|------|
| **UI + Logic** | Webflow + Wized |
| **Backend** | Supabase (Postgres + RLS + Functions + Realtime Chat) |
| **Payments** | Stripe Checkout + Webhooks |
| **Hosting** | Vercel Pro (CI/CD via GitHub) |
| **AI Development** | Claude Code (CLI), Claude Pro, GPT-5, Cursor |
| **Version Control** | GitHub |
| **Realtime Chat** | Supabase Realtime (via conversations + messages tables) |

💬 **Chat Implementation Note:**  
The MVP uses Supabase Realtime to store and sync conversations (`conversations` + `messages` tables). Future versions may migrate to Stream or Pusher Channels for scalability once chat volume increases.

---

## 🗓️ Next Milestone

**Q1/Q2 2026:** invite-only beta for first 100 climbers  
(3 dynamically-priced climbing trips with Denver Mountain Guiding)

---

## 🏔️ About ShayrdAir

Founded in Boulder, Colorado, ShayrdAir is building the one-stop, asset-light marketplace for the $1T outdoor economy — combining experiences, gear, and membership savings through data-driven, AI-powered group pricing.

---

# ShayrdAir MVP Blueprint
## Business Overview, Context, and Product Roadmap

**Date:** December 2025

This document includes a business overview, historical business context, technical documentation such as system architecture, and a product roadmap with key milestones and project management details.

---

## What is ShayrdAir's mission?

To make outdoor adventure more accessible and affordable for everyone.

**Company Website:** www.shayrdair.com

---

## What does ShayrdAir make and what does it do?

ShayrdAir makes outdoor experiences cheaper through group pricing. We're starting with premium climbing trips, then expanding into other outdoor sports as the model scales. Guides host; we handle bookings, payments, and logistics. Once the marketplace is running smoothly, we'll launch a $60/year membership that gives members exclusive access to our group-priced experiences and discounted gear and apparel. The platform is asset-light — no inventory, AI automates coordination — and together these layers position ShayrdAir to become the one-stop Costco for the $1T outdoor economy.

---

## The Fully Built Solution

In the fully built version of our platform, members pay a $60 annual fee to join our exclusive community. This upfront model allows us to pool funds to purchase gear, apparel, and adventure essentials at wholesale prices, passing those savings directly to our members.

We apply the same savings approach to experiences through a dynamic, tiered pricing model based on group size.

| Group Size | Price/Person | Total |
|------------|--------------|-------|
| 1 signup   | $700         | $700  |
| 2 signups  | $600         | $1,200 |
| 3 signups  | $500         | $1,500 |
| 4 signups  | $450         | $1,800 |
| 5 signups  | $500         | $2,500 |

That pricing mechanism is the backbone for ShayrdAir's experiences marketplace and creates a win-win model where bigger groups unlock better prices for everyone.

---

## Personalization

Members complete a brief onboarding quiz to share their interests, style, and budget. We use that data to generate tailored recommendations and deliver them regularly via email — helping members navigate their adventure journey with confidence.

---

## MVP Overview

We're starting with the experiences side of the platform to validate the dynamic pricing engine and guide partnerships before expanding to gear and apparel.

**Core MVP functionality:**
* Manage min/max participant counts per experience.
* Display dynamic pricing as sign-ups increase (public and private group formats).
* Integrate custom Supabase availability tables per guide and experience.
* Support secure, account-based messaging between customers and guides.
* Enable seamless, mobile-first account creation.
* Automate refunds/savings redistribution when group size increases.

---

## MVP Build Philosophy

Prioritize speed to market for validation and iteration, while laying a scalable foundation for gear and apparel expansion.

---

## First Partner Launch

**Denver Mountain Guiding (DMG)** — a premier guide service based in Denver, CO.

**Initial offerings:**
1. Lake City Ice Climbing
2. Introduction to Ice Climbing
3. Ski Mountaineering 101

---

## Target Customer

Aspiring and experienced climbers, ages 23 – 54, living in major urban and suburban areas.

---

## Founder Context

* MBA with strong business and outdoor industry experience
* Non-technical founder leveraging AI tools to launch MVP
* Previously generated $44K climbing program revenue + $30K gear GMV
* April–May 2025 pilot ($3,960 GMV → $792 revenue, 20% take) proved prepayment for group pricing

---

## Brand Essence

Inspiring, Social, Minimal, Convenient, Innovative

**Websites we admire:** Airbnb, Thrive Market  
**Websites we avoid emulating:** REI, Oak App

---

## Location

Boulder, Colorado — the epicenter of U.S. climbing and outdoor sports.

Strong user base, guide network, and startup ecosystem.

---

## Progress Summary

* ✅ Customer validation complete
* ✅ Paid pilots run with real customers and partners
* 🔧 MVP in development using Webflow + Wized + Supabase + Stripe + Vercel
* 🚀 Invite-only beta launch planned for February 2026

---

## Stack Summary

**Frontend:** Webflow + Wized (UI, logic, and chat interface)  
**Backend:** Supabase/Postgres + RLS (data, authentication, and Realtime chat)  
**Realtime / Chat Layer:** Supabase Realtime (via conversations + messages tables)  
**Payments:** Stripe (Checkout + webhooks)  
**Hosting:** Vercel (deployments + CI/CD)  
**AI Tools:** GPT-5, Claude, Cursor (AI-assisted development)

💬 **Chat Implementation Note:**  
The MVP uses Supabase Realtime to sync live chat between customers and guides. Future versions may migrate to Stream or Pusher Channels if chat volume or scaling requirements increase.

---

## 🧩 Dynamic Pricing Model

ShayrdAir's core innovation is dynamic group pricing: costs decrease as more people join the same trip. This is implemented via the `pricing_tiers` table, which maps exact party sizes to per-person prices.

**Example:**
| Party Size | Price/Person | Total |
|------------|--------------|-------|
| 1 person   | $700         | $700  |
| 2 people   | $600         | $1,200 |
| 4 people   | $450         | $1,800 |

**Technical Implementation:**  
See [ADR-0002 — Dynamic Pricing Model](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/decisions/ADR-0002.md) for full architectural decision and rationale.

---

---

## Roadmap Milestones

* ✅ Apr – May 2025: Paid pilot validated demand
* 🔧 Oct 2025: MVP technical build (current phase)
* 🚀 Feb 2026: Invite-only beta launch
* 💰 Q3 2026: Membership + gear integration

---

## Vision

Combine experiences, gear, and membership into a single ecosystem for the modern adventurer — the one-stop Costco for the $1T outdoor economy.

---

## 📊 Interview & Product Documentation

The following documents provide executive-level context and quantified achievements for stakeholder conversations:

- [Product Overview](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/PRODUCT_OVERVIEW.md)  
  *Executive summary of ShayrdAir's mission, MVP scope, AI-native development methodology, and transferable learnings. Read this first for high-level context.*

- [Achievements](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/ACHIEVEMENTS.md)  
  *Quantified technical accomplishments: 10-table schema with 21 foreign key relationships, RLS policies, 6-week build timeline, and velocity metrics.*

- [Frontend Showcase](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/frontend-showcase.md)  
  *Responsive design strategy, Webflow MCP integration, design patterns replicated from Airbnb, and systematic CSS debugging methodology.*

These documents complement the technical documentation below and provide context for non-technical stakeholders evaluating the project.

---

## 📚 Reference Documents

All detailed documentation for ShayrdAir lives in the `/docs` folder.  
You can open each file directly on GitHub or retrieve it through AI assistants (Claude, GPT-5, Cursor, etc.) using the commands and prompts below.

### 🔗 Direct Links (for Human Collaborators)

- [Architecture Overview](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/architecture.md)  
  *Describes the system architecture, environment layout, and data flow between Webflow, Wized, Supabase, Stripe, and Vercel.*

- [ADR-0001 — Stack Decision](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/decisions/ADR-0001.md)  
  *Explains why ShayrdAir chose its current tech stack (Webflow + Wized + Supabase + Stripe + Vercel) and the rationale behind each component.*

- [Webflow → Vercel SOP](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/workflows/webflow-vercel.md)  
  *Provides the standard operating procedure for exporting from Webflow and deploying to Vercel.*

- [Claude Migration Summary](https://github.com/ShayrdAirHQ/shayrdair-mvp/blob/main/docs/ai/Claude-Migration-Summary.md)  
  *Outlines how ShayrdAir's Claude Pro and Claude Code environments were set up and synchronized with GitHub.*

---

### 💻 Local Access (for Developers)

Clone and open the documentation locally:

```bash
git clone https://github.com/ShayrdAirHQ/shayrdair-mvp.git
cd shayrdair-mvp/docs
ls
open architecture.md     # or code architecture.md in VS Code
```

---

### 🤖 Retrieval Instructions (for AI Assistants)

When using Claude Code, Claude Pro, GPT-5, or Cursor, simply refer to these files by path. The AI assistants are configured to automatically read from `/docs` when you mention one of these prompts:

* "Show me the architecture overview in docs/architecture.md."
* "List all ADRs under /docs/decisions."
* "Summarize the Claude Migration Summary document."
* "Explain the Webflow → Vercel SOP in /docs/workflows/webflow-vercel.md."

Claude (and other connected tools) will locate these Markdown files and reference them directly.

---

*Maintained with Claude Code — last verified in context December 2025.*

---

## 🧭 Repository Status

**Branch:** main | **Tag:** cofounder-ready-20251022-1809  
**Last Updated:** December 2025