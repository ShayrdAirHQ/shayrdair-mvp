BEGIN;
DROP POLICY IF EXISTS "public read published experiences" ON public.experiences;
CREATE POLICY "public read published experiences"
  ON public.experiences
  FOR SELECT
  TO anon, authenticated
  USING (status = 'published');

DROP POLICY IF EXISTS "public read tiers for published" ON public.pricing_tiers;
CREATE POLICY "public read tiers for published"
  ON public.pricing_tiers
  FOR SELECT
  TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.experiences e
    WHERE e.id = pricing_tiers.experience_id AND e.status = 'published'
  ));

DROP POLICY IF EXISTS "public read upcoming for published" ON public.availabilities;
CREATE POLICY "public read upcoming for published"
  ON public.availabilities
  FOR SELECT
  TO anon, authenticated
  USING (
    starts_at >= (now() - interval '1 hour') AND
    EXISTS (
      SELECT 1 FROM public.experiences e
      WHERE e.id = availabilities.experience_id AND e.status = 'published'
    )
  );

DROP POLICY IF EXISTS "public read guides for published" ON public.guides;
CREATE POLICY "public read guides for published"
  ON public.guides
  FOR SELECT
  TO anon, authenticated
  USING (EXISTS (
    SELECT 1 FROM public.experiences e
    WHERE e.guide_id = guides.id AND e.status = 'published'
  ));
COMMIT;
