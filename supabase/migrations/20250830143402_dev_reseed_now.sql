BEGIN;
SELECT dev.bump_seed_availabilities();  -- +7d/+14d, 4h blocks
COMMIT;
