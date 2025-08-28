drop policy if exists "experiences_public_read_published" on public.experiences;

do $$
declare
  _data_type text;
  _udt_name text;
begin
  select data_type, udt_name
  into _data_type, _udt_name
  from information_schema.columns
  where table_schema='public' and table_name='experiences' and column_name='status';

  if _data_type = 'text' then
    execute $p$ create policy "experiences_public_read_published" on public.experiences
      for select using (status = 'published'); $p$;
  else
    execute $p$ create policy "experiences_public_read_published" on public.experiences
      for select using (true); $p$;
  end if;
end $$;
