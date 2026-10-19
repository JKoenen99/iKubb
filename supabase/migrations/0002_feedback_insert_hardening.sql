-- Applied on 2026-10-19 (Supabase advisor "RLS Policy Always True").
--
-- 1. The insert policy checks the shape of a row instead of being always
--    true: a schema-v1 document whose embedded id matches the row, a
--    plausible timestamp (offline outboxes may be weeks old), and bounded
--    sizes. Altered in place so the role never loses insert access.
alter policy "anon can insert feedback" on public.feedback_events
  with check (
    (payload ->> 'schema_version')::int = 1
    and payload ->> 'event_id' = event_id::text
    and occurred_at between now() - interval '30 days' and now() + interval '1 hour'
    and pg_column_size(payload) <= 8192
    and cardinality(tags) <= 10
    and char_length(locale) <= 16
    and char_length(app_version) <= 32
    and char_length(platform) <= 16
  );

alter policy "anon can insert feedback" on public.feedback_events
  rename to "anon can insert well-formed feedback";

-- 2. Rate limit per installation: at most 30 events per hour. The
--    function runs as its owner (it may count rows the app key cannot
--    read) and lives in a schema the API never exposes.
create schema if not exists private;
revoke all on schema private from anon, authenticated;

create or replace function private.feedback_rate_limit()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (
    select count(*)
    from public.feedback_events
    where install_id = new.install_id
      and received_at > now() - interval '1 hour'
  ) >= 30 then
    raise exception 'feedback rate limit exceeded for this installation'
      using errcode = 'P0001';
  end if;
  return new;
end
$$;

revoke execute on function private.feedback_rate_limit() from public, anon, authenticated;

create trigger feedback_rate_limit
  before insert on public.feedback_events
  for each row execute function private.feedback_rate_limit();
