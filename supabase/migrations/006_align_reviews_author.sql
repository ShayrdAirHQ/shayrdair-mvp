do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='reviews' and column_name='user_id'
  ) and not exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='reviews' and column_name='customer_user_id'
  ) then
    alter table public.reviews rename column user_id to customer_user_id;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.reviews'::regclass
      and conname = 'reviews_customer_user_id_fkey'
  ) then
    alter table public.reviews
      add constraint reviews_customer_user_id_fkey
      foreign key (customer_user_id) references public.users(id) on delete cascade;
  end if;

  create index if not exists idx_reviews_customer on public.reviews(customer_user_id);

  drop policy if exists "reviews_author_write" on public.reviews;
  create policy "reviews_author_write" on public.reviews
    for all using (customer_user_id = auth.uid())
    with check (customer_user_id = auth.uid());
end $$;
