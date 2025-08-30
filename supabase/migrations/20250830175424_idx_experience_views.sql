BEGIN;
CREATE INDEX IF NOT EXISTS idx_experiences_slug ON public.experiences (slug);
CREATE INDEX IF NOT EXISTS idx_tiers_exp_qty ON public.pricing_tiers (experience_id, quantity_min);
CREATE INDEX IF NOT EXISTS idx_avail_exp_starts ON public.availabilities (experience_id, starts_at);
COMMIT;
