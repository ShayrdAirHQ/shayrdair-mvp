alter table public.users enable row level security;
alter table public.guides enable row level security;
alter table public.experiences enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.pricing_tiers enable row level security;
alter table public.reviews enable row level security;
alter table public.availabilities enable row level security;

create policy "users_select_own" on public.users
  for select using (auth.uid() = id);
create policy "users_update_own" on public.users
  for update using (auth.uid() = id);

create policy "guides_public_read" on public.guides
  for select using (true);
create policy "guides_owner_write" on public.guides
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "experiences_public_read_published" on public.experiences
  for select using (status::text = 'published');
create policy "experiences_owner_write" on public.experiences
  for all using (
    exists (select 1 from public.guides g where g.id = experiences.guide_id and g.user_id = auth.uid())
  )
  with check (
    exists (select 1 from public.guides g where g.id = experiences.guide_id and g.user_id = auth.uid())
  );

create policy "conversations_participants_read" on public.conversations
  for select using (auth.uid() in (customer_user_id, guide_user_id));
create policy "conversations_participants_write" on public.conversations
  for all using (auth.uid() in (customer_user_id, guide_user_id))
  with check (auth.uid() in (customer_user_id, guide_user_id));

create policy "messages_participants_read" on public.messages
  for select using (
    exists (select 1 from public.conversations c
            where c.id = messages.conversation_id
              and auth.uid() in (c.customer_user_id, c.guide_user_id))
  );
create policy "messages_participants_write" on public.messages
  for all using (
    exists (select 1 from public.conversations c
            where c.id = messages.conversation_id
              and auth.uid() in (c.customer_user_id, c.guide_user_id))
  )
  with check (sender_user_id = auth.uid());

create policy "pricing_tiers_public_read" on public.pricing_tiers
  for select using (true);
create policy "pricing_tiers_owner_write" on public.pricing_tiers
  for all using (
    exists (
      select 1 from public.experiences e
      join public.guides g on g.id = e.guide_id
      where e.id = pricing_tiers.experience_id and g.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.experiences e
      join public.guides g on g.id = e.guide_id
      where e.id = pricing_tiers.experience_id and g.user_id = auth.uid()
    )
  );

create policy "reviews_public_read" on public.reviews
  for select using (true);
create policy "reviews_author_write" on public.reviews
  for all using (customer_user_id = auth.uid())
  with check (customer_user_id = auth.uid());

create policy "availabilities_public_read" on public.availabilities
  for select using (true);
create policy "availabilities_owner_write" on public.availabilities
  for all using (guide_user_id = auth.uid())
  with check (guide_user_id = auth.uid());
