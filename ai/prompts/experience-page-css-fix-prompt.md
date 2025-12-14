# ShayrdAir Experience Page CSS Fix — Power Prompt

## Project Context
I'm building ShayrdAir, an outdoor adventure marketplace MVP using Webflow + Wized + Supabase + Stripe. I'm a non-technical founder using AI tools to build. Airbnb Experiences is my UX reference.

Staging site: shayrdair-v9.webflow.io

## Current Problem
My experience template page has a two-column layout with a sticky pricing sidebar. At widescreen breakpoints, there are white space gaps because the CSS is over-engineered.

## Page Structure
- Parent container: CSS Grid with `grid-template-columns: 1.45fr 1fr`
- Left column: Stacked content blocks (hero, description, highlights, itinerary, things to know, reviews, location map)
- Right column: Sticky pricing cards (Open Booking, Guaranteed Private, Private Group)
- Breakpoint: Collapses to single column at 991px

## Current CSS (Problem)
```css
.right-column-wrapper {
  display: grid !important;
  grid-template-rows: auto auto auto minmax(675px, 1fr) !important;
  align-items: start !important;
  gap: 0 !important;
  min-height: 2340px !important;
}

.pricing-options-wrapper {
  position: sticky !important;
  top: 97px !important;
  align-self: start !important;
  row-gap: 12px !important;
}
```

## Proposed Fix (Needs Testing)
```css
/* Parent container */
.experience-columns {
  display: grid;
  grid-template-columns: 1.45fr 1fr;
  gap: 24px;
  align-items: start;
}

/* Right column - just sticky, no grid */
.right-column-wrapper {
  position: sticky;
  top: 97px;
  align-self: start;
}

/* Pricing cards - flexbox for internal spacing */
.pricing-options-wrapper {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* Tablet/mobile collapse */
@media (max-width: 991px) {
  .experience-columns {
    grid-template-columns: 1fr;
  }
  .right-column-wrapper {
    position: relative;
    top: 0;
  }
}
```

## Goal
Fix responsive behavior from widescreen (1920px+) down to mobile (480px) while keeping pricing cards sticky — matching Airbnb's experience page pattern where the sticky sidebar follows naturally without white space gaps.

## What I Need
Help me test and refine this CSS fix. I'll share screenshots of:
1. Current state at problem breakpoints
2. Webflow Navigator showing element hierarchy
3. Chrome DevTools showing computed styles

Guide me through applying the fix in Webflow and iterating until it works across all breakpoints.
