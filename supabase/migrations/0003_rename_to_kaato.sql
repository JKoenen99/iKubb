-- The app is called Kaato since 0.4.0 (it was iKubb). Migrations are
-- append-only, so 0001 keeps the old name in its comments; this updates
-- the description stored in the database. Metadata only: no data, policy
-- or permission changes.
comment on table public.feedback_events is
  'In-app feedback from Kaato (formerly iKubb). payload is the canonical document (schema_version inside).';
