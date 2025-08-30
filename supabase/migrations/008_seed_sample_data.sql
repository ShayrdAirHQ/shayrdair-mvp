BEGIN;

ALTER TABLE public.pricing_tiers
  ADD COLUMN IF NOT EXISTS min_group_size smallint,
  ADD COLUMN IF NOT EXISTS max_group_size smallint,
  ADD COLUMN IF NOT EXISTS price numeric(10,2),
  ADD COLUMN IF NOT EXISTS price_cents integer,
  ADD COLUMN IF NOT EXISTS quantity_min smallint,
  ADD COLUMN IF NOT EXISTS quantity_max smallint,
  ADD COLUMN IF NOT EXISTS label text,
  ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();

ALTER TABLE public.availabilities
  ADD COLUMN IF NOT EXISTS guide_user_id uuid,
  ADD COLUMN IF NOT EXISTS start_at timestamptz,
  ADD COLUMN IF NOT EXISTS end_at timestamptz,
  ADD COLUMN IF NOT EXISTS slots_total integer,
  ADD COLUMN IF NOT EXISTS slots_booked integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS status text DEFAULT 'open',
  ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();

DELETE FROM public.pricing_tiers
WHERE experience_id = '55555555-5555-5555-5555-555555555555'
  AND id NOT IN (
    '66666666-6666-6666-6666-666666666661',
    '66666666-6666-6666-6666-666666666662',
    '66666666-6666-6666-6666-666666666663'
  );

INSERT INTO public.users (id, email, full_name, role, phone_number, created_at) VALUES
('11111111-1111-1111-1111-111111111111','guide.alex@example.com','Alex Rivera','guide','+1-720-555-0101',now()),
('22222222-2222-2222-2222-222222222222','customer.taylor@example.com','Taylor Kim','customer','+1-303-555-0202',now()),
('33333333-3333-3333-3333-333333333333','admin.test@example.com','Admin Test','admin','+1-970-555-0303',now())
ON CONFLICT (id) DO UPDATE
SET email=EXCLUDED.email, full_name=EXCLUDED.full_name, role=EXCLUDED.role, phone_number=EXCLUDED.phone_number;

INSERT INTO public.guides (id, user_id, bio, profile_image_url, created_at) VALUES
('44444444-4444-4444-4444-444444444444','11111111-1111-1111-1111-111111111111','AMGA Single-Pitch Instructor with 10+ years guiding in Clear Creek and Eldorado Canyon. Patient, safety-first, stoked on helping climbers progress.','https://images.example.com/guides/alex-rivera.jpg',now())
ON CONFLICT (id) DO UPDATE
SET user_id=EXCLUDED.user_id, bio=EXCLUDED.bio, profile_image_url=EXCLUDED.profile_image_url;

INSERT INTO public.experiences (
  id, guide_id, created_at, title, slug, short_description, description,
  location_name, location_lat, location_lng,
  duration_label, duration_hours, trip_type, difficulty_level, season,
  max_group_size, price_base, price_step, price_minimum,
  hero_image_url, gallery_image_urls, video_embed_url,
  status, featured, internal_notes, tags,
  meta_title, meta_description, calendar_embed_code
) VALUES (
  '55555555-5555-5555-5555-555555555555','44444444-4444-4444-4444-444444444444',now(),
  'Clear Creek Canyon: Sport Climbing Progression (Half Day)',
  'clear-creek-sport-progression-half-day',
  'Level up your sport climbing with a half-day progression in Clear Creek Canyon.',
  'Dial in your lead skills, clipping, stance management, and anchor cleaning with Alex. Ideal for climbers leading 5.8–5.10 looking to progress safely.',
  'Clear Creek Canyon, CO',39.7439,-105.2433,
  'Half Day',4,'single-day','intermediate','spring,summer,fall',
  6,225.00,25.00,125.00,
  'https://images.example.com/experiences/ccc-hero.jpg',
  ARRAY['https://images.example.com/experiences/ccc-1.jpg','https://images.example.com/experiences/ccc-2.jpg'],
  NULL,'published',FALSE,'Seed: DEV only. Use for integration tests.',
  ARRAY['sport','progression','clear creek'],
  'Clear Creek Sport Progression – Half Day',
  'Half-day guided sport climbing progression in Clear Creek Canyon with AMGA SPI guide.',
  NULL
)
ON CONFLICT (id) DO UPDATE
SET guide_id=EXCLUDED.guide_id, title=EXCLUDED.title, slug=EXCLUDED.slug, short_description=EXCLUDED.short_description,
    description=EXCLUDED.description, location_name=EXCLUDED.location_name, location_lat=EXCLUDED.location_lat,
    location_lng=EXCLUDED.location_lng, duration_label=EXCLUDED.duration_label, duration_hours=EXCLUDED.duration_hours,
    trip_type=EXCLUDED.trip_type, difficulty_level=EXCLUDED.difficulty_level, season=EXCLUDED.season,
    max_group_size=EXCLUDED.max_group_size, price_base=EXCLUDED.price_base, price_step=EXCLUDED.price_step,
    price_minimum=EXCLUDED.price_minimum, hero_image_url=EXCLUDED.hero_image_url, gallery_image_urls=EXCLUDED.gallery_image_urls,
    video_embed_url=EXCLUDED.video_embed_url, status=EXCLUDED.status, featured=EXCLUDED.featured,
    internal_notes=EXCLUDED.internal_notes, tags=EXCLUDED.tags, meta_title=EXCLUDED.meta_title,
    meta_description=EXCLUDED.meta_description, calendar_embed_code=EXCLUDED.calendar_embed_code;

INSERT INTO public.pricing_tiers
  (id, experience_id, min_group_size, max_group_size, quantity_min, quantity_max, price_cents, price, label, created_at) VALUES
('66666666-6666-6666-6666-666666666661','55555555-5555-5555-5555-555555555555',1,1,1,1,22500,225.00,'Solo',now()),
('66666666-6666-6666-6666-666666666662','55555555-5555-5555-5555-555555555555',2,3,2,3,17500,175.00,'Small group',now()),
('66666666-6666-6666-6666-666666666663','55555555-5555-5555-5555-555555555555',4,6,4,6,13500,135.00,'Crew rate',now())
ON CONFLICT (id) DO UPDATE
SET experience_id=EXCLUDED.experience_id,
    min_group_size=EXCLUDED.min_group_size,
    max_group_size=EXCLUDED.max_group_size,
    quantity_min=EXCLUDED.quantity_min,
    quantity_max=EXCLUDED.quantity_max,
    price_cents=EXCLUDED.price_cents,
    price=EXCLUDED.price,
    label=EXCLUDED.label;

INSERT INTO public.availabilities
  (id, experience_id, guide_user_id, start_at, end_at, slots_total, slots_booked, status, created_at) VALUES
('77777777-7777-7777-7777-777777777771','55555555-5555-5555-5555-555555555555','11111111-1111-1111-1111-111111111111',
 (now()+INTERVAL '7 days')::timestamptz,(now()+INTERVAL '7 days'+INTERVAL '4 hours')::timestamptz,6,0,'open',now()),
('77777777-7777-7777-7777-777777777772','55555555-5555-5555-5555-555555555555','11111111-1111-1111-1111-111111111111',
 (now()+INTERVAL '14 days')::timestamptz,(now()+INTERVAL '14 days'+INTERVAL '4 hours')::timestamptz,6,2,'open',now())
ON CONFLICT (id) DO UPDATE
SET experience_id=EXCLUDED.experience_id,
    guide_user_id=EXCLUDED.guide_user_id,
    start_at=EXCLUDED.start_at,
    end_at=EXCLUDED.end_at,
    slots_total=EXCLUDED.slots_total,
    slots_booked=EXCLUDED.slots_booked,
    status=EXCLUDED.status;

INSERT INTO public.conversations (id, created_at, customer_user_id, guide_user_id, experience_id, last_message_at, status) VALUES
('88888888-8888-8888-8888-888888888888',now(),'22222222-2222-2222-2222-222222222222','11111111-1111-1111-1111-111111111111','55555555-5555-5555-5555-555555555555',now(),'open')
ON CONFLICT (id) DO UPDATE
SET customer_user_id=EXCLUDED.customer_user_id, guide_user_id=EXCLUDED.guide_user_id, experience_id=EXCLUDED.experience_id,
    last_message_at=EXCLUDED.last_message_at, status=EXCLUDED.status;

INSERT INTO public.messages (id, conversation_id, sender_user_id, content, created_at) VALUES
('99999999-9999-9999-9999-999999999991','88888888-8888-8888-8888-888888888888','22222222-2222-2222-2222-222222222222','Hey Alex! Stoked to book this half-day—do you think it''s suitable if I''m comfortably leading 5.9?',now()),
('99999999-9999-9999-9999-999999999992','88888888-8888-8888-8888-888888888888','11111111-1111-1111-1111-111111111111','Absolutely! We''ll tailor objectives to your level and focus on safe progression. Morning or afternoon work better?',now())
ON CONFLICT (id) DO UPDATE
SET conversation_id=EXCLUDED.conversation_id, sender_user_id=EXCLUDED.sender_user_id, content=EXCLUDED.content;

INSERT INTO public.reviews (id, experience_id, author_user_id, rating, title, body, created_at) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','55555555-5555-5555-5555-555555555555','22222222-2222-2222-2222-222222222222',5,'Exactly what I needed to progress','Alex delivered an awesome, safety-focused half day. Clear coaching on clipping and cleaning anchors—left feeling confident to push into 5.10.',now())
ON CONFLICT (id) DO UPDATE
SET experience_id=EXCLUDED.experience_id, author_user_id=EXCLUDED.author_user_id, rating=EXCLUDED.rating, title=EXCLUDED.title, body=EXCLUDED.body;

UPDATE public.conversations
SET last_message_at = GREATEST(last_message_at, (SELECT MAX(created_at) FROM public.messages WHERE conversation_id = conversations.id))
WHERE id = '88888888-8888-8888-8888-888888888888';

COMMIT;


