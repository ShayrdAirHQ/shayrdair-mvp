# ShayrdAir Product Overview
## AI-Native MVP Development: A Case Study

**Author:** Tim (Founder & Solo Builder)  
**Context:** Product demonstration for Housecall Pro CPO interview  
**Last Updated:** December 2025

---

## Executive Summary

ShayrdAir is an asset-light marketplace for outdoor adventures featuring **dynamic group pricing** that lowers per-person costs as more participants join. Built entirely by a non-technical MBA founder using AI-assisted development tools, this MVP demonstrates a systematic approach to AI-native product development that compressed 4-6 months of traditional development into **6 weeks of part-time work**.

**What makes this unique:**
- Sophisticated backend (10-table Postgres schema with Row-Level Security)
- Production-grade frontend (responsive, Airbnb-quality UX)
- Zero traditional engineering hires
- Systematic AI collaboration methodology (not just "prompting ChatGPT")
- Transferable learnings applicable to any product development organization

---

## The Product: What ShayrdAir Does

### Core Value Proposition
**Make outdoor adventures more accessible through group economics.**

Traditional guided experiences are expensive for solo travelers ($700+). ShayrdAir's dynamic pricing model lowers costs as groups form:

| Group Size | Price/Person | You Save |
|------------|--------------|----------|
| 1 person   | $700         | -        |
| 2 people   | $600         | $100     |
| 4 people   | $450         | $250     |

### MVP Scope (February 2026 Beta)
- **Experience marketplace:** 3 climbing trips with Denver Mountain Guiding
- **Dynamic pricing engine:** Real-time price updates as bookings increase
- **Secure messaging:** In-platform communication between customers and guides
- **Payment infrastructure:** Stripe integration with automatic savings redistribution
- **Availability management:** Guide-side scheduling and capacity tracking

### Business Model Validation
- **April-May 2025 pilot:** $3,960 GMV with 20% take rate ($792 revenue)
- **Previous climbing program:** $44K revenue + $30K gear GMV through brand partnerships
- **Future expansion:** $60/year membership for gear discounts (Costco model)

---

## The Technical Build: What I Actually Built

### Backend Infrastructure (Supabase/Postgres)
**10-table relational database with 21 foreign key relationships**

Core entities and business logic:
- **Users table** with role-based access control (admin|guide|customer)
- **Guides table** with profile and bio management
- **Experiences table** with 20+ fields including geolocation, media, SEO metadata
- **Pricing_tiers table** with unique constraints for dynamic group pricing
- **Bookings table** connecting customers, experiences, and payment status
- **Conversations + Messages tables** for real-time chat infrastructure
- **Availabilities table** for guide scheduling and capacity management
- **Reviews table** for post-experience feedback (planned)

**Advanced features:**
- Row-Level Security (RLS) policies enforcing role-based permissions
- JSONB fields for flexible metadata (gallery images, tags)
- Geospatial data types for location-based features
- Enum types for status fields (draft|active|archived, etc.)
- Referential integrity with cascade deletes where appropriate
- Timestamp tracking for audit trails

### Frontend Implementation (Webflow + Custom CSS)
**Responsive layouts modeled after Airbnb's design system**

Key accomplishments:
- Two-column experience detail pages with sticky pricing sidebar
- Mobile-first responsive design (320px to 1920px+ breakpoints)
- CSS Grid for complex layouts without framework bloat
- Airbnb-quality typography hierarchy and visual polish
- Webflow MCP integration for accelerated design-to-code workflow

### Payment Infrastructure (Stripe)
- Checkout Session API integration
- Webhook handling for payment status updates
- Automatic savings redistribution logic (when group size increases)
- Support for refunds and cancellations

---

## The Methodology: How I Built It

### AI-Native Development Approach

**Not "just prompting" - this is systematic AI collaboration:**

1. **Context Management System**
   - Architecture Decision Records (ADRs) documenting key technical choices
   - Automated context export scripts for seamless AI tool switching
   - "Semantic ground truth" documentation that AI assistants reference
   - Systematic prompt engineering with task-specific templates

2. **Multi-Tool Workflow**
   - **Claude Code (CLI):** Direct filesystem access, bash execution, complex logic
   - **GPT-5:** Rapid prototyping and exploration
   - **Cursor:** Code editor integration for inline assistance
   - **Webflow MCP:** Design-to-code workflow pioneered within 48 hours of release

3. **Quality Assurance**
   - Git branching strategy (protected main, feature branches, PRs)
   - Schema documentation auto-generated from live database
   - Reversible migrations with rollback plans
   - Systematic debugging with detailed screenshots and computed CSS values

### Velocity Metrics
- **Traditional estimate:** 4-6 months with engineering team
- **Actual timeline:** 6 weeks part-time (while working full-time at Vantage Risk)
- **Cost savings:** $0 in engineering salaries (pre-revenue startup)
- **Quality achieved:** Production-grade architecture, not prototype

---

## Transferable Learnings for Product Organizations

### 1. AI-Assisted Development Is Ready for Production Use
**Finding:** With proper methodology, non-technical founders can build production-grade MVPs
- Not limited to prototypes or "hello world" apps
- Requires systematic approach (documentation, context management, testing)
- Quality depends on product thinking, not just code generation

### 2. Documentation Becomes Product Infrastructure
**Finding:** Comprehensive docs enable AI collaboration at scale
- ADRs create institutional memory for solo founders
- Schema documentation prevents drift between DB and application layer
- Context export scripts allow seamless tool switching (Claude → GPT → Cursor)

### 3. Speed-to-Market Without Technical Debt
**Finding:** AI enables rapid development while maintaining clean architecture
- 10-table normalized schema with proper foreign keys (not NoSQL shortcuts)
- Row-Level Security policies from day one (not "we'll add auth later")
- Git workflow with branching and PRs (not cowboy commits to main)

### 4. The "Non-Technical Founder" Myth
**Finding:** Product expertise + AI tools > traditional engineering in MVP phase
- Deep domain knowledge (outdoor industry, climbing) guided architecture decisions
- Business logic embedded in database constraints (pricing_tiers unique constraint)
- UX patterns borrowed from best-in-class products (Airbnb) via visual analysis

### 5. Webflow MCP as Competitive Advantage
**Finding:** Early adoption of cutting-edge tooling creates moats
- Pioneered integration within 48 hours of MCP release
- Eliminated design-to-code translation layer
- Systematic debugging methodology for CSS and responsive design

---

## Validation for Product Management Roles

### Why This Matters for Senior PM Positions

**Demonstrates:**
1. **Systems thinking:** 10-table schema shows understanding of data relationships
2. **User-centered design:** Airbnb-modeled UX shows empathy for user experience
3. **Technical fluency:** Can speak credibly to engineering teams about architecture
4. **Execution velocity:** Shipped production-grade MVP in 6 weeks part-time
5. **AI-native skillset:** Positioned for future of product development (2025+)

**De-risks:**
- "Can this PM work with engineers?" → Built the entire MVP alone
- "Does this PM understand data models?" → Designed normalized 10-table schema
- "Can this PM ship?" → Live staging environment, February 2026 beta planned
- "Is this PM just an idea person?" → Wrote the SQL, CSS, and integrated Stripe

---

## What's Next: Roadmap

### Near-Term (Q1/Q2 2026)
- February 2026: Invite-only beta launch (100 climbers, 3 experiences)
- Partner validation with Denver Mountain Guiding
- Unit economics testing at scale


---

## Repository Structure

```
shayrdair-mvp/
├── docs/
│   ├── architecture.md          ← System design overview
│   ├── PRODUCT_OVERVIEW.md      ← This document
│   ├── ACHIEVEMENTS.md          ← Quantified accomplishments
│   ├── frontend-showcase.md     ← Frontend work documentation
│   └── decisions/
│       ├── ADR-0001.md          ← Stack selection rationale
│       └── ADR-0002.md          ← Dynamic pricing model
├── db/schema/
│   └── SCHEMA.md                ← Database documentation
├── ai/
│   ├── context/                 ← AI context management
│   └── prompts/                 ← Task-specific templates
└── scripts/
    ├── export-context.sh        ← Context packaging for AI
    └── update-schema-docs.sh    ← Schema auto-documentation
```

---

*Built with Claude Code, GPT-5, and Cursor - December 2025*