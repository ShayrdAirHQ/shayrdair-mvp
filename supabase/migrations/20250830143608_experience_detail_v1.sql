BEGIN;

CREATE OR REPLACE VIEW public.experience_detail_v1 AS
SELECT
  e.id                            AS experience_id,
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
  g.id                            AS guide_id,
  u.full_name                     AS guide_name,
  COALESCE(
    json_agg(
      json_build_object(
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
    ) FILTER (WHERE pt.id IS NOT NULL),
    '[]'::json
  ) AS pricing_tiers,
  COALESCE(
    json_agg(
      DISTINCT jsonb_build_object(
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
    ) FILTER (WHERE a.id IS NOT NULL),
    '[]'::json
  ) AS availabilities
FROM public.experiences e
LEFT JOIN public.guides g       ON g.id = e.guide_id
LEFT JOIN public.users  u       ON u.id = g.user_id
LEFT JOIN public.pricing_tiers pt ON pt.experience_id = e.id
LEFT JOIN public.availabilities a ON a.experience_id  = e.id
GROUP BY e.id, g.id, u.full_name;

COMMIT;
