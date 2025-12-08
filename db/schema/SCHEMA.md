# ShayrdAir — Database Schema (Reference)

## users
- id (uuid, pk)
- email (text, unique, not null)
- full_name (text)
- role (enum: admin|guide|customer)
- phone_number (text)
- created_at (timestamptz, default now)
**Notes:** Base auth identity.

## guides
- id (uuid, pk)
- user_id (uuid, fk → users.id)
- bio (text)
- profile_image_url (text)
- created_at (timestamptz, default now)
**FKs:** guides.user_id → users.id (on delete cascade)

## experiences
- id (uuid, pk)
- guide_id (uuid, fk → guides.id)
- created_at (timestamptz, default now)
- title (text)
- slug (text, unique)
- short_description (text)
- description (text)
- location_name (text)
- location_lat (numeric)
- location_lng (numeric)
- duration_label (text)
- duration_hours (numeric)
- trip_type (enum)
- difficulty_level (enum)
- season (text)
- max_group_size (int)
- price_base (numeric)          # optional legacy anchor
- price_step (numeric)          # optional legacy anchor
- price_minimum (numeric)       # optional legacy anchor
- hero_image_url (text)
- gallery_image_urls (jsonb)
- video_embed_url (text)
- status (enum: draft|active|archived)
- featured (bool)
- internal_notes (text)
- tags (text[])
- meta_title (text)
- meta_description (text)
- calendar_embed_code (text)
**FKs:** experiences.guide_id → guides.id

## pricing_tiers
- id (uuid, pk)
- experience_id (uuid, fk → experiences.id)
- party_size (int)              # exact group size
- price_per_person (numeric)
- label (text)                  # optional display label
- created_at (timestamptz, default now)
**Unique:** (experience_id, party_size)
**Purpose:** exact party-size pricing for dynamic group pricing.

## bookings (planned/active)
- id (uuid, pk)
- experience_id (uuid, fk → experiences.id)
- customer_user_id (uuid, fk → users.id)
- party_size (int)
- selected_tier_id (uuid, fk → pricing_tiers.id)
- total_amount (numeric)
- stripe_checkout_id (text)
- stripe_payment_intent (text)
- status (enum: pending|paid|canceled|refunded)
- created_at (timestamptz, default now)

## conversations (active)
- id (uuid, pk)
- created_at (timestamptz, default now)
- customer_user_id (uuid, fk → users.id)
- guide_user_id (uuid, fk → users.id)
- experience_id (uuid, fk → experiences.id, nullable)
- last_message_at (timestamptz)
- status (enum: open|archived|closed)

## messages (active)
- id (uuid, pk)
- conversation_id (uuid, fk → conversations.id)
- sender_user_id (uuid, fk → users.id)
- body (text)
- created_at (timestamptz, default now)

## reviews (planned)
- id (uuid, pk)
- booking_id (uuid, fk → bookings.id)
- rating (int)
- comment (text)
- created_at (timestamptz, default now)

## availabilities (active, guide-side)
- id (uuid, pk)
- guide_user_id (uuid, fk → users.id)
- experience_id (uuid, fk → experiences.id, nullable)
- start_time (timestamptz)
- end_time (timestamptz)
- capacity (int)
- status (enum: open|held|booked|canceled)

## Foreign Key Map (quick view)
- guides.user_id → users.id
- experiences.guide_id → guides.id
- pricing_tiers.experience_id → experiences.id
- bookings.experience_id → experiences.id
- bookings.customer_user_id → users.id
- bookings.selected_tier_id → pricing_tiers.id
- conversations.customer_user_id → users.id
- conversations.guide_user_id → users.id
- conversations.experience_id → experiences.id
- messages.conversation_id → conversations.id
- messages.sender_user_id → users.id
- reviews.booking_id → bookings.id
- availabilities.guide_user_id → users.id
- availabilities.experience_id → experiences.id

## RLS & Security (to document next)
- users: self-read/update
- conversations/messages: participants-only
- bookings: customer + guide on experience
- pricing_tiers/experiences: public read, admin/guide write
