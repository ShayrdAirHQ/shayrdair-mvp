begin;

create extension if not exists pgcrypto;

alter table public.users           alter column id set default gen_random_uuid();
alter table public.guides          alter column id set default gen_random_uuid();
alter table public.experiences     alter column id set default gen_random_uuid();
alter table public.availabilities  alter column id set default gen_random_uuid();
alter table public.conversations   alter column id set default gen_random_uuid();
alter table public.messages        alter column id set default gen_random_uuid();
alter table public.pricing_tiers   alter column id set default gen_random_uuid();
alter table public.reviews         alter column id set default gen_random_uuid();

commit;
