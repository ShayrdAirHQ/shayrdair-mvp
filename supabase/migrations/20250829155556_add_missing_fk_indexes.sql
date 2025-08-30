begin;

create index if not exists idx_availabilities_experience_id on public.availabilities(experience_id);
create index if not exists idx_conversations_customer_user_id on public.conversations(customer_user_id);
create index if not exists idx_conversations_experience_id on public.conversations(experience_id);
create index if not exists idx_conversations_guide_user_id on public.conversations(guide_user_id);
create index if not exists idx_experiences_guide_id on public.experiences(guide_id);
create index if not exists idx_guides_user_id on public.guides(user_id);
create index if not exists idx_messages_sender_user_id on public.messages(sender_user_id);
create index if not exists idx_pricing_tiers_experience_id on public.pricing_tiers(experience_id);
create index if not exists idx_reviews_experience_id on public.reviews(experience_id);

commit;


