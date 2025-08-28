do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='availabilities' and column_name='guide_user_id'
  ) then
    create index if not exists idx_availabilities_guide_time on public.availabilities(guide_user_id, starts_at);
  elsif exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='availabilities' and column_name='guide_id'
  ) then
    create index if not exists idx_availabilities_guide_time on public.availabilities(guide_id, starts_at);
  end if;
end $$;
