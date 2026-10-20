create table if not exists public.user_deck_data (
  user_id uuid primary key references auth.users (id) on delete cascade,
  decks jsonb not null default '[]'::jsonb
    check (jsonb_typeof(decks) = 'array'),
  updated_at timestamptz not null default now()
);

alter table public.user_deck_data enable row level security;

grant select, insert, update on public.user_deck_data to authenticated;

drop policy if exists "Users can read their own deck data"
  on public.user_deck_data;
create policy "Users can read their own deck data"
  on public.user_deck_data
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own deck data"
  on public.user_deck_data;
create policy "Users can create their own deck data"
  on public.user_deck_data
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own deck data"
  on public.user_deck_data;
create policy "Users can update their own deck data"
  on public.user_deck_data
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
