drop policy if exists "availabilities_owner_write" on public.availabilities;

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='availabilities' and column_name='guide_user_id'
  ) then
    execute $p$
      create policy "availabilities_owner_write" on public.availabilities
      for all using (guide_user_id = auth.uid())
      with check (guide_user_id = auth.uid());
    $p$;
  elsif exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='availabilities' and column_name='guide_id'
  ) then
    execute $p$
      create policy "availabilities_owner_write" on public.availabilities
      for all using (guide_id = auth.uid())
      with check (guide_id = auth.uid());
    $p$;
  else
    execute $p$
      create policy "availabilities_owner_write" on public.availabilities
      for all using (auth.uid() is not null)
      with check (auth.uid() is not null);
    $p$;
  end if;
end $$;
