# ShayrdAir Frontend Showcase
## Responsive Design & Webflow MCP Integration

**Last Updated:** December 2025  
**Context:** Frontend development by non-technical founder using AI-assisted workflows

---

## 🎨 Design Philosophy

### Core Principles
- **Airbnb-inspired UX:** Best-in-class patterns for marketplace trust and conversion
- **Mobile-first responsive:** Building every component to work at 320px and scale to 1920px+
- **Performance-optimized:** Minimal JavaScript, CSS Grid for layouts
- **Accessibility-conscious:** Semantic HTML, proper heading hierarchy
- **AI-native workflow:** Webflow MCP for design-to-code velocity

### Design Benchmarks
We systematically studied and replicated successful patterns from:
- **Airbnb Experiences:** Two-column layout, sticky pricing, trust signals
- **Thrive Market:** Membership model, savings emphasis, clean typography
- **Modern SaaS:** Button styles, card components, spacing systems

---

## 📱 Responsive Design System

### Breakpoint Strategy

| Breakpoint | Width | Use Case | Key Changes |
|------------|-------|----------|-------------|
| Mobile     | 320-767px | Phone portrait/landscape | Single column, stacked pricing, hamburger menu |
| Tablet     | 768-1023px | iPad portrait | Two-column with adjusted ratios, collapsible sections |
| Desktop    | 1024-1279px | Laptop screens | Full two-column, sticky pricing, expanded nav |
| Wide       | 1280px+ | Large monitors | Max-width container (1280px), centered layout |

### Typography Scale
- **Mobile base:** 16px body, 24px H1, 20px H2, 18px H3
- **Desktop base:** 18px body, 32px H1, 24px H2, 20px H3
- **Line height:** 1.5 for body, 1.2 for headings
- **Font stack:** System fonts (San Francisco, Segoe UI, Roboto)

### Spacing System
Consistent 8px grid:
- **Micro spacing:** 8px, 16px (within components)
- **Component spacing:** 24px, 32px (between elements)
- **Section spacing:** 48px, 64px (major page divisions)
- **Page margins:** 16px mobile, 24px tablet, 32px desktop

---

## 🏗️ Key UI Components

### 1. Experience Detail Page

**Layout Structure:**
```
[Hero Image - Full Width]
[Two-Column Container]
  [Left Column - 60%]
    - Experience Title (H1)
    - Location + Duration + Difficulty
    - Description (Rich Text)
    - What's Included (Bulleted List)
    - Itinerary (Accordion)
    - Gallery (Image Grid)
    - Reviews Section
  [Right Column - 40%]
    - Pricing Card (Sticky)
    - Party Size Selector
    - Pricing Tiers Table
    - Book Now CTA
    - Host Profile Card
    - Cancellation Policy
```

**Responsive Behavior:**
- **Mobile:** Single column, pricing card fixed at bottom
- **Tablet:** Two-column with 50/50 ratio, sticky disabled
- **Desktop:** Two-column with 60/40 ratio, sticky enabled

### 2. Sticky Pricing Sidebar

**CSS Implementation:**
```css
.pricing-sidebar {
  position: sticky;
  top: 24px;
  max-height: calc(100vh - 48px);
  overflow-y: auto;
}
```

**Features:**
- Stays visible during scroll (desktop only)
- Max height prevents overflow on short screens
- Smooth scroll behavior for party size selection
- Real-time price updates via Wized

### 3. Dynamic Pricing Tiers Table

**Visual Design:**
- Clean table with alternating row colors
- Highlighted "selected tier" state
- Savings badge for larger groups
- Mobile: Vertical cards instead of table

**Data Binding (Wized):**
- Once wired, Wized will fetch `pricing_tiers` from Supabase
- Filter by `experience_id`
- Sort by `party_size` ascending
- Calculate savings vs. solo price

### 4. Button System

**Variants:**
- **Primary:** Blue fill, white text, hover darkens
- **Secondary:** White fill, blue text, hover lightens
- **Outline:** Transparent fill, blue border, hover fills
- **Ghost:** Transparent, blue text, hover underlines

**States:**
- Default, Hover, Active, Disabled
- Loading spinner for async actions
- Responsive sizing (44px mobile, 48px desktop)

### 5. Card Components

**Experience Card (Listing):**
- Image with gradient overlay
- Title + Location
- Price range indicator
- Difficulty badge
- Hover: Lift effect (box-shadow)

**Host Profile Card:**
- Circular avatar
- Name + Bio
- Response rate + Rating
- Message button

---

## 🚀 Webflow MCP Integration

### What is Webflow MCP?

**Model Context Protocol (MCP)** for Webflow enables AI assistants to:
- Read Webflow project structure
- Analyze CSS computed values
- Inspect element hierarchy
- Debug responsive breakpoints
- Propose code changes

### Integration Timeline
- **November 2025:** MCP released by Anthropic
- **Within 48 hours:** Integrated into ShayrdAir workflow
- **Result:** Will debug CSS 10x faster CSS, eliminating translation layer

### Workflow Example: Fixing Sticky Pricing

**Traditional Approach (2-3 hours):**
1. Export HTML from Webflow
2. Inspect in DevTools
3. Identify CSS issue
4. Fix in Webflow
5. Re-export and test
6. Repeat if broken

**Webflow MCP Approach (15 minutes):**
1. Claude Code reads Webflow project directly
2. Identifies `position: sticky` not working
3. Proposes fix: parent container needs `overflow: visible`
4. Apply fix in Webflow
5. Verified via MCP
6. Done

---

## 📐 Design Patterns Replicated from Airbnb

### Trust Signals
- **Host profile:** Photo, bio, response rate, reviews
- **Verified badge:** For established guides
- **Cancellation policy:** Clearly stated upfront
- **Secure payment:** Stripe badge, "You won't be charged yet"

### Booking Flow UX
1. Browse experiences (cards with key info)
2. Click for details (full page with gallery)
3. Select party size (dynamic pricing updates)
4. Review booking (summary + total)
5. Enter payment (Stripe Checkout)
6. Confirmation (email + in-app notification)

### Visual Hierarchy
- **Hero image first:** Emotional appeal
- **Key details next:** Price, location, difficulty
- **Deep content below fold:** Full description, itinerary
- **Sticky CTA always visible:** Reduce decision friction

---

## 🎯 Technical Challenges Solved

### Challenge 1: Sticky Pricing on Mobile
**Problem:** Sticky sidebar obscures content on small screens  
**Solution:** Disable sticky on mobile, use fixed bottom bar instead  
**CSS:**
```css
@media (max-width: 1023px) {
  .pricing-sidebar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 100;
  }
}
```

### Challenge 2: CSS Grid Browser Support
**Problem:** Older browsers don't support CSS Grid  
**Solution:** Feature detection + flexbox fallback  
**CSS:**
```css
@supports (display: grid) {
  .layout {
    display: grid;
    grid-template-columns: 60% 40%;
  }
}
@supports not (display: grid) {
  .layout {
    display: flex;
  }
}
```

### Challenge 3: Image Optimization
**Problem:** Large hero images slow page load  
**Solution:** Webflow's responsive images + lazy loading  
**Implementation:**
- Webflow auto-generates WebP formats
- Lazy load images below fold
- Hero image preloaded for LCP optimization

### Challenge 4: Spacing Inconsistencies
**Problem:** Webflow designer shows different spacing than published site  
**Solution:** Export computed CSS, compare, adjust in Webflow  
**Workflow:**
1. Use MCP to read computed values
2. Identify discrepancies (usually inherited margins)
3. Add explicit spacing in Webflow
4. Verify via live preview

---

## 📊 Performance Metrics

### Lighthouse Scores (Target)
- **Performance:** 90+
- **Accessibility:** 95+
- **Best Practices:** 95+
- **SEO:** 100

### Optimization Techniques
- **Critical CSS:** Inline above-the-fold styles
- **Lazy loading:** Images, iframes
- **Font optimization:** System font stack (no web fonts)
- **Minimal JS:** Webflow + Wized only, no heavy frameworks


*Built with Webflow + Webflow MCP + Claude Code - December 2025*