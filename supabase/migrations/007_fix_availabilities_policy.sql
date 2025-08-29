drop policy if exists "availabilities_owner_write" on public.availabilities;

create policy "availabilities_owner_write" on public.availabilities
for all using (
  exists (
    select 1
    from public.availabilities a
    where a.id = availabilities.id and (
      (
        (select count(*) from information_schema.columns
          where table_schema='public' and table_name='availabilities' and column_name='guide_user_id') > 0
        and a.guide_user_id = auth.uid()
      )
      or
      (
        (select count(*) from information_schema.columns
          where table_schema='public' and table_name='availabilities' and column_name='guide_id') > 0
        and a.guide_id = auth.uid()
      )
    )
  )
)
with check (
  exists (
    select 1
    from public.availabilities a
    where a.id = availabilities.id and (
      (
        (select count(*) from information_schema.columns
          where table_schema='public' and table_name='availabilities' and column_name='guide_user_id') > 0
        and a.guide_user_id = auth.uid()
      )
      or
      (
        (select count(*) from information_schema.columns
          where table_schema='public' and table_name='availabilities' and column_name='guide_id') > 0
        and a.guide_id = auth.uid()
      )
    )
  )
);
