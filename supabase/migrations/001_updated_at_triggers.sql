create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

do $$ declare r record; begin
  for r in
    select table_name
    from information_schema.columns
    where table_schema='public' and column_name='updated_at'
  loop
    execute format('
      drop trigger if exists set_updated_at_%I on public.%I;
      create trigger set_updated_at_%I
      before update on public.%I
      for each row
      execute procedure public.update_updated_at_column();',
      r.table_name, r.table_name, r.table_name, r.table_name
    );
  end loop;
end $$;
