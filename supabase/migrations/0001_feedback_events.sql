-- iKubb in-app feedback. One row per prompt moment (submitted or
-- dismissed). The full system-independent document lives in `payload`;
-- the other columns are extracted copies for indexing, GROUP BY and
-- dashboards. Moving to another system = `select payload from ...`.
--
-- Applied to the project on 2026-10-19 through the Supabase connector
-- (as three migrations: table, policy, views). Kept here as the single
-- source of truth for a fresh project: supabase db push / SQL editor.

create table if not exists public.feedback_events (
  event_id      uuid        primary key,
  install_id    uuid        not null,
  occurred_at   timestamptz not null,
  received_at   timestamptz not null default now(),
  trigger       text        not null check (trigger in ('game_end', 'tour_end', 'settings')),
  response      text        not null check (response in ('submitted', 'dismissed')),
  rating        smallint    check (rating between 1 and 5),
  tags          text[]      not null default '{}',
  comment       text        check (char_length(comment) <= 300),
  locale        text        not null,
  app_version   text        not null,
  platform      text        not null,
  payload       jsonb       not null
);

comment on table public.feedback_events is
  'In-app feedback from iKubb. payload is the canonical document (schema_version inside).';

create index if not exists feedback_events_occurred_at_idx on public.feedback_events (occurred_at desc);
create index if not exists feedback_events_install_idx     on public.feedback_events (install_id, occurred_at);
create index if not exists feedback_events_tags_idx        on public.feedback_events using gin (tags);
create index if not exists feedback_events_payload_idx     on public.feedback_events using gin (payload jsonb_path_ops);

-- The app ships the publishable (anon) key: it may append rows and
-- nothing else. No select/update/delete policy for anon: reading is for
-- you (dashboard / SQL editor / service role) only.
alter table public.feedback_events enable row level security;

create policy "anon can insert feedback"
  on public.feedback_events for insert
  to anon
  with check (true);

grant insert on public.feedback_events to anon;

-- Handy views for analysis -------------------------------------------------

-- Response rate and average rating per trigger and app version.
create or replace view public.feedback_summary
  with (security_invoker = true) as
select
  app_version,
  trigger,
  count(*)                                               as prompts,
  count(*) filter (where response = 'submitted')         as submitted,
  round(100.0 * count(*) filter (where response = 'submitted') / count(*), 1) as response_pct,
  round(avg(rating) filter (where response = 'submitted'), 2)                as avg_rating,
  count(*) filter (where rating >= 4)                    as promoters,
  count(*) filter (where rating <= 2)                    as detractors
from public.feedback_events
group by app_version, trigger
order by app_version desc, trigger;

-- Tag frequency, split by sentiment.
create or replace view public.feedback_tag_counts
  with (security_invoker = true) as
select
  case when rating >= 4 then 'positive' else 'improvement' end as sentiment,
  unnest(tags)                                                 as tag,
  count(*)                                                     as n
from public.feedback_events
where response = 'submitted'
group by 1, 2
order by 1, n desc;

-- Ratings by game mode (from the context document).
create or replace view public.feedback_by_mode
  with (security_invoker = true) as
select
  payload -> 'context' ->> 'mode'            as mode,
  round(avg(rating), 2)                       as avg_rating,
  count(*)                                    as n
from public.feedback_events
where response = 'submitted' and trigger = 'game_end'
group by 1
order by n desc;

-- Supabase's default privileges hand new objects REFERENCES/TRIGGER/
-- TRUNCATE for the API roles; the app key needs none of that.
revoke references, trigger, truncate
  on public.feedback_events, public.feedback_summary,
     public.feedback_tag_counts, public.feedback_by_mode
  from anon, authenticated;
