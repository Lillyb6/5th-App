-- Give every Supabase account a starter deck row so the app has seed content
-- immediately after sign-up and when an existing account first signs in.
create or replace function public.seed_user_deck_data()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.user_deck_data (user_id, decks)
  values (
    new.id,
    $starter_decks$[
      {
        "title": "Biology essentials",
        "cards": [
          {"term": "Mitochondria", "answer": "The organelles that produce most of a cell’s ATP."},
          {"term": "Photosynthesis", "answer": "The process plants use to convert light into chemical energy."},
          {"term": "Osmosis", "answer": "Movement of water across a selectively permeable membrane."}
        ],
        "seconds": 0
      }
    ]$starter_decks$::jsonb
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists seed_user_deck_data_after_signup on auth.users;
create trigger seed_user_deck_data_after_signup
  after insert on auth.users
  for each row execute function public.seed_user_deck_data();

-- Also seed accounts that existed before this migration was applied.
insert into public.user_deck_data (user_id, decks)
select
  users.id,
  $starter_decks$[
    {
      "title": "Biology essentials",
      "cards": [
        {"term": "Mitochondria", "answer": "The organelles that produce most of a cell’s ATP."},
        {"term": "Photosynthesis", "answer": "The process plants use to convert light into chemical energy."},
        {"term": "Osmosis", "answer": "Movement of water across a selectively permeable membrane."}
      ],
      "seconds": 0
    }
  ]$starter_decks$::jsonb
from auth.users as users
on conflict (user_id) do nothing;
