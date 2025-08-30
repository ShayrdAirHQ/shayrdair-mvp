BEGIN;

DROP VIEW IF EXISTS public.experience_detail_v1;

CREATE VIEW public.experience_detail_v1 AS
SELECT
  e.id               AS experience_id,
  e.title,
  e.slug,
  e.short_description,
  e.location_name,
  e.duration_label,
  e.duration_hours,
  e.max_group_size,
  e.price_base,
  e.price_step,
  e.price_minimum,
  g.id               AS guide_id,
  u.full_name        AS guide_name,

  COALESCE(
    (
      SELECT jsonb_agg(
               jsonb_build_object(
                 'id', pt.id,
                 'label', pt.label,
                 'quantity_min', pt.quantity_min,
                 'quantity_max', pt.quantity_max,
                 'min_group_size', pt.min_group_size,
                 'max_group_size', pt.max_group_size,
                 'price_cents', pt.price_cents,
                 'price', pt.price
               )
               ORDER BY pt.quantity_min
             )
      FROM public.pricing_tiers pt
      WHERE pt.experience_id = e.id
    ),
    '[]'::jsonb
  ) AS pricing_tiers,

  COALESCE(
    (
      SELECT jsonb_agg(
               jsonb_build_object(
                 'id', a.id,
                 'starts_at', a.starts_at,
                 'ends_at', a.ends_at,
                 'capacity', a.capacity,
                 'slots_total', a.slots_total,
                 'slots_booked', a.slots_booked,
                 'status', a.status,
                 'guide_user_id', a.guide_user_id
               )
               ORDER BY a.starts_at
             )
      FROM public.availabilities a
      WHERE a.experience_id = e.id
    ),
    '[]'::jsonb
  ) AS availabilities

FROM public.experiences e
LEFT JOIN public.guides g ON g.id = e.guide_id
LEFT JOIN public.users  u ON u.id = g.user_id;

COMMIT;

