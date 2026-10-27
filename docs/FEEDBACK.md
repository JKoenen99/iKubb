# In-app feedback: momenten, data en analyse

Doel: aan het einde van een bezoek leren wat spelers van de app vinden
(sterren + pills + korte tekst, à la Airbnb), met data die van jou is,
systeem-onafhankelijk opgeslagen wordt en direct te analyseren is.

## 1. De momenten in de journey

| Moment | Trigger-id | Waarom hier | Frequentie |
|---|---|---|---|
| Winscherm, onder Rematch/Delen/Nieuw spel | `game_end` | Het natuurlijke "einde van het bezoek": de uitslag staat nog in beeld, de emotie is er, niemand zit midden in een worp. De kaart staat onder de acties zodat hij nooit concurreert met Rematch. | Eerst na het **tweede** afgeronde spel. Na "Niet nu": na 10 spellen of 30 dagen. Na een antwoord: pas na 20 spellen **en** 30 dagen. Nooit twee keer binnen 12 uur. |
| Laatste kaart van de tour ("Leer het spel") | `tour_end` | Meet de onboarding los van het scoren: hielp de uitleg? | Eén keer ooit, bij de eerste voltooiing. |
| Instellingen → Feedback → "Feedback geven" | `settings` | Ongevraagde feedback is vaak de rijkste; de ingang moet altijd vindbaar zijn. | Altijd. |

Mechaniek: de inline kaart toont één zin en vijf sterren, nooit modaal.
Een ster opent het formulier met die ster voorgeselecteerd. De pills
volgen de rating: bij 4–5 sterren "Wat werkte goed?", bij 1–3 "Wat kan
beter?". Daarna een optioneel tekstveld (max 300 tekens) en één
verstuurknop. Wie het formulier wegswipet nadat hij sterren koos, levert
een `dismissed`-event mét rating op: afhaken is ook data.

Marketing: een rating van 4 of 5 loopt door naar de native
store-reviewprompt (`SKStoreReviewController` / Google In-App Review),
hooguit eens per 90 dagen. Kritiek (≤3) gaat juist naar het tekstveld en
komt bij jou terecht, niet in de store.

Regels staan in `lib/features/feedback/feedback_scheduler.dart` en zijn
getest zonder UI (`test/feedback_rules_test.dart`).

## 2. Het datamodel (schema v1)

Eén plat JSON-document per promptmoment. Dit document is het contract:
het staat zo in de lokale outbox, zo in Supabase (`payload`) en kan zo
naar elk ander systeem (BigQuery, een spreadsheet, `jq`).

```json
{
  "schema_version": 1,
  "event_id": "4d1c…",            // UUID v4, idempotency-key
  "install_id": "9a7b…",          // UUID v4 per installatie, géén account
  "occurred_at": "2026-10-19T20:14:03.120Z",
  "trigger": "game_end",          // game_end | tour_end | settings
  "response": "submitted",        // submitted | dismissed
  "rating": 5,                    // 1–5, null bij dismissed zonder sterren
  "tags": ["easy_scoring", "looks_great"],   // stabiele ids, nooit vertaalde tekst
  "comment": "Super snel!",       // getrimd, ≤300 tekens, null als leeg
  "locale": "nl-NL",
  "app_version": "0.1.0",
  "build_number": "1",
  "platform": "ios",
  "os_version": "Version 26.0 (Build 23A…)",
  "store_review_requested": true,
  "context": {                    // trigger-specifiek, altijd platte primitieven
    "mode": "number_kubb",
    "sides": 2,
    "throws": 23,
    "target_score": 50,
    "overshoot_policy": "resetToFixed",
    "elimination": true,
    "eliminated_sides": 0,
    "input_mode": "pins"
  }
}
```

Context per trigger:

- `game_end` number kubb: `mode`, `sides`, `throws`, `target_score`,
  `overshoot_policy`, `elimination`, `eliminated_sides`, `input_mode`.
- `game_end` classic kubb (alleen builds vóór 0.4.0): `mode`, `best_of`,
  `games`, `turn_clock_seconds`, `early_king`, `events`.
- `tour_end`: `mode` (sinds 0.4.0 altijd `number_kubb`).
- `settings`: leeg.

Tag-ids (`lib/features/feedback/feedback_tags.dart`):
positief `easy_scoring`, `rules_helpful`, `looks_great`, `fast`,
`stats_fun`, `share_card`; verbeterpunten `confusing`, `missing_feature`,
`bug`, `too_many_taps`, `rules_unclear`, `translation`; beide `other`.
Een id verandert nooit; nieuwe ids toevoegen is additief.

## 3. Privacy

- Geen account, naam, e-mail, locatie of device-identifier. Alleen een
  random `install_id` dat bij herinstallatie verdwijnt.
- App Store privacy-label: "Product Interaction / Other Usage Data,
  Analytics, **not linked to you**". Geen tracking, geen ATT-prompt.
- De tekst in het formulier zegt precies wat bewaard wordt.
- De anon key in de app mag alleen **INSERT** op de feedbacktabel (RLS);
  lezen kan uitsluitend met jouw service role / dashboard.
- De insert-policy controleert de vorm van een rij (schema v1, id in het
  document gelijk aan de rij, tijdstip binnen 30 dagen, begrensde
  groottes) en een trigger beperkt het tot 30 events per installatie per
  uur, zodat de publieke key niet voor spam te gebruiken is
  (`supabase/migrations/0002_feedback_insert_hardening.sql`).

## 4. Opslag: lokaal eerst, dan Supabase

1. **Outbox op het toestel** (`FeedbackRepository`, shared_preferences):
   elk event wordt eerst lokaal bewaard, daarna naar de sink gestuurd en
   bij succes als gesynchroniseerd gemarkeerd. Mislukt het (offline), dan
   wordt het bij de volgende app-start en na het volgende event opnieuw
   geprobeerd. `exportJsonLines()` geeft alles als JSON Lines.
2. **Sink** (`FeedbackSink`): een interface met één methode. De
   Supabase-implementatie praat met de PostgREST-endpoint via `http`,
   zonder SDK. Een andere backend is één klasse van ~30 regels.
3. **Supabase**: `supabase/migrations/0001_feedback_events.sql` maakt de
   tabel met het volledige document in `payload jsonb` plus losse
   kolommen voor indexen en GROUP BY, de RLS-policy, en drie views.

### Supabase: ingericht op 2026-10-19

Project `cebkosufhtkddecfroij` (eu-west-1, Postgres 17). In het
Supabase-dashboard heet het nog `iKubb`; hernoemen kan daar en verandert
niets aan de URL of de sleutels. De migraties 0001 en 0002 zijn via de
Supabase-connector uitgevoerd (tabel, policy, views, rate limit) en
geverifieerd: de anon-rol kan invoegen, kan niet lezen (42501) en een
dubbele `event_id` geeft 23505 (REST: 409). De security-advisor meldt
niets. Migratie 0003 (alleen de tabelomschrijving, van iKubb naar Kaato)
staat klaar maar is nog niet uitgevoerd. Migraties zijn append-only: pas
een uitgevoerde nooit aan, voeg een nieuwe toe. Voor een vers project of
de openstaande migratie: `supabase link` + `supabase db push`, of de SQL
uit `supabase/migrations/` in volgorde in de SQL-editor plakken.

Build-configuratie (publishable key is publiek; RLS beperkt hem tot
invoegen):

```sh
flutter build ipa \
  --dart-define=SUPABASE_URL=https://cebkosufhtkddecfroij.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_qaavkaafBNirBzeW9k3toA_FOi_Dx-d
```

Let op: de REST-call stuurt één event per request en behandelt 409 als
"al opgeslagen"; `ON CONFLICT` zou SELECT-rechten vereisen die de app-key
bewust niet heeft. Een definitieve afwijzing (andere 4xx, bijvoorbeeld
door de policy) wordt uit de outbox verwijderd; 408/429 en 5xx worden
opnieuw geprobeerd.

Zonder deze defines draait de app met alleen de lokale outbox (dat is
wat de tests doen; de webpreview bouwt mét backend).

## 5. Analyse

Kant-en-klare views (in de migratie):

- `feedback_summary`: prompts, antwoorden, response-%, gemiddelde rating,
  promoters (≥4) en detractors (≤2) per appversie en trigger.
- `feedback_tag_counts`: hoe vaak elke pill gekozen is, gesplitst in
  positief/verbeterpunt.
- `feedback_by_mode`: gemiddelde rating per spelmodus.

Voorbeelden:

```sql
-- Verbeterpunten met tekst, nieuwste eerst
select occurred_at, rating, tags, comment, app_version, locale
from feedback_events
where response = 'submitted' and rating <= 3
order by occurred_at desc;

-- Response-rate van het winscherm per versie
select app_version, response_pct, avg_rating from feedback_summary
where trigger = 'game_end';

-- Alles als JSON Lines exporteren (verhuizen naar een ander systeem)
select payload from feedback_events order by occurred_at;

-- Rating versus aantal worpen (lange spellen = andere ervaring?)
select (payload->'context'->>'throws')::int / 10 * 10 as throws_bucket,
       round(avg(rating), 2), count(*)
from feedback_events
where trigger = 'game_end' and response = 'submitted'
group by 1 order by 1;
```

Omdat `install_id` stabiel is binnen een installatie, kun je ook
trends per speler volgen (eerste vs. latere rating) zonder iemand te
kennen.

## 6. Code-overzicht

| Bestand | Rol |
|---|---|
| `feedback_event.dart` | Het document (schema v1), to/fromJson |
| `feedback_tags.dart` | Pill-ids en vertaalde labels |
| `feedback_repository.dart` | Install-id, promptstatus, outbox, export |
| `feedback_sink.dart` | `FeedbackSink`, `SupabaseFeedbackSink`, `NoopFeedbackSink` |
| `feedback_scheduler.dart` | Pure eligibility-regels |
| `feedback_controller.dart` | Riverpod-koppeling, store-review, outbox-flush, spelteller |
| `feedback_prompt.dart` | Inline sterrenkaart (winscherm, tour) |
| `feedback_sheet.dart` | Het formulier (bottom sheet) |
| `star_rating.dart` | Vijf toegankelijke sterren |
