BEGIN;
DROP VIEW IF EXISTS public.list_experiences_v1;
CREATE VIEW public.list_experiences_v1 AS
SELECT
  e.id AS experience_id,
  e.title,
  e.slug,
  e.short_description,
  e.hero_image_url,
  e.location_name,
  e.duration_label,
  e.duration_hours,
  (SELECT MIN(pt.price) FROM public.pricing_tiers pt WHERE pt.experience_id = e.id) AS min_price,
  (SELECT MIN(pt.price_cents) FROM public.pricing_tiers pt WHERE pt.experience_id = e.id) AS min_price_cents,
  (SELECT MIN(a.starts_at) FROM public.availabilities a WHERE a.experience_id = e.id AND a.status = 'open' AND a.starts_at >= now()) AS next_start_at,
  (SELECT MIN(a.ends_at) FROM public.availabilities a WHERE a.experience_id = e.id AND a.status = 'open' AND a.starts_at >= now()) AS next_end_at
FROM public.experiences e
WHERE e.status = 'published';
COMMIT;
