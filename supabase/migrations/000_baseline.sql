create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

do $$ begin
  if not exists (select 1 from pg_type where typname = 'conversation_status') then
    create type conversation_status as enum ('open','archived','closed');
  end if;
end $$;

create table if not exists public.users (
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  full_name text,
  role text,
  phone_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.guides (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  bio text,
  profile_image_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.experiences (
  id uuid primary key default uuid_generate_v4(),
  guide_id uuid not null references public.guides(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  title text not null,
  slug text unique not null,
  short_description text,
  description text,
  location_name text,
  location_lat double precision,
  location_lng double precision,
  duration_label text,
  duration_hours numeric,
  trip_type text,
  difficulty_level text,
  season text,
  max_group_size integer,
  price_base integer,
  price_step integer,
  price_minimum integer,
  hero_image_url text,
  gallery_image_urls text[],
  video_embed_url text,
  status text default 'draft',
  featured boolean default false,
  internal_notes text,
  tags text[],
  meta_title text,
  meta_description text,
  calendar_embed_code text
);

create table if not exists public.conversations (
  id uuid primary key default uuid_generate_v4(),
  created_at timestamptz not null default now(),
  last_message_at timestamptz not null default now(),
  customer_user_id uuid not null references public.users(id),
  guide_user_id uuid not null references public.users(id),
  experience_id uuid references public.experiences(id),
  status conversation_status not null default 'open',
  updated_at timestamptz not null default now()
);

create table if not exists public.messages (
  id uuid primary key default uuid_generate_v4(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_user_id uuid not null references public.users(id),
  content text not null
);

create table if not exists public.pricing_tiers (
  id uuid primary key default uuid_generate_v4(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  experience_id uuid not null references public.experiences(id) on delete cascade,
  label text,
  quantity_min integer not null,
  quantity_max integer,
  price_cents integer not null
);

create table if not exists public.reviews (
  id uuid primary key default uuid_generate_v4(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  experience_id uuid not null references public.experiences(id) on delete cascade,
  customer_user_id uuid not null references public.users(id),
  rating smallint not null check (rating between 1 and 5),
  title text,
  body text
);

create table if not exists public.availabilities (
  id uuid primary key default uuid_generate_v4(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  guide_user_id uuid not null references public.users(id) on delete cascade,
  experience_id uuid references public.experiences(id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  capacity integer not null check (capacity > 0),
  spots_remaining integer,
  notes text
);

create index if not exists idx_experiences_slug on public.experiences(slug);
create index if not exists idx_messages_conversation on public.messages(conversation_id);
create index if not exists idx_availabilities_guide_time on public.availabilities(guide_user_id, starts_at);
