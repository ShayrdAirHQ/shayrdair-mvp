BEGIN;
DO $$
BEGIN
  IF to_regnamespace('dev') IS NULL THEN
    IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'dev') THEN
      EXECUTE 'DROP SCHEMA dev CASCADE';
    END IF;
    RETURN;
  END IF;

  CREATE SCHEMA IF NOT EXISTS dev;

  CREATE OR REPLACE FUNCTION dev.bump_seed_availabilities(
     first_days int DEFAULT 7,
     second_days int DEFAULT 14,
     block_hours int DEFAULT 4,
     second_booked int DEFAULT 2
  ) RETURNS void
  LANGUAGE plpgsql
  AS $f$
  BEGIN
    UPDATE public.availabilities
    SET starts_at = (now() + make_interval(days => first_days)),
        ends_at   = (now() + make_interval(days => first_days, hours => block_hours)),
        start_at  = COALESCE(start_at, (now() + make_interval(days => first_days))),
        end_at    = COALESCE(end_at,   (now() + make_interval(days => first_days, hours => block_hours))),
        slots_booked = 0,
        status = 'open'
    WHERE id = '77777777-7777-7777-7777-777777777771';

    UPDATE public.availabilities
    SET starts_at = (now() + make_interval(days => second_days)),
        ends_at   = (now() + make_interval(days => second_days, hours => block_hours)),
        start_at  = COALESCE(start_at, (now() + make_interval(days => second_days))),
        end_at    = COALESCE(end_at,   (now() + make_interval(days => second_days, hours => block_hours))),
        slots_booked = second_booked,
        status = 'open'
    WHERE id = '77777777-7777-7777-7777-777777777772';
  END;
  $f$;

  CREATE OR REPLACE FUNCTION dev.clear_seed()
  RETURNS void
  LANGUAGE plpgsql
  AS $f$
  BEGIN
    DELETE FROM public.messages WHERE conversation_id = '88888888-8888-8888-8888-888888888888';
    DELETE FROM public.conversations WHERE id = '88888888-8888-8888-8888-888888888888';
    DELETE FROM public.reviews WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
    DELETE FROM public.availabilities WHERE id IN ('77777777-7777-7777-7777-777777777771','77777777-7777-7777-7777-777777777772');
    DELETE FROM public.pricing_tiers WHERE id IN ('66666666-6666-6666-6666-666666666661','66666666-6666-6666-6666-666666666662','66666666-6666-6666-6666-666666666663');
    DELETE FROM public.experiences WHERE id = '55555555-5555-5555-5555-555555555555';
    DELETE FROM public.guides WHERE id = '44444444-4444-4444-4444-444444444444';
    DELETE FROM public.users WHERE id IN ('11111111-1111-1111-1111-111111111111','22222222-2222-2222-2222-222222222222','33333333-3333-3333-3333-333333333333');
  END;
  $f$;
END $$;
COMMIT;

