# Kaato — Number Kubb Scoreboard

**Specification & feature list — living document, current with version
0.4.0.** Everything here is built unless it is marked *(planned)*. How
the work is done (branches, checks, versions) lives in `AGENTS.md`; the
history of what changed when, in `CHANGELOG.md`.

A scoreboard app for **number kubb** ("Scandinavisch kegelspel", the
Mölkky-style game with 12 numbered pins). The name is Finnish: *kaato*
is the felling, the knocked-over pin. It replaces pen-and-paper
scoring with a fast, mistake-proof scoring tool, teaches the rules to new
players, and keeps long-term player statistics. Scandinavian modern design with
Viking illustration assets. Built with Flutter so one codebase ships to the
iOS App Store first and Google Play later, with future monetization and an
animation-heavy experience in mind (see §6).

---

## 1. Product overview

| | |
|---|---|
| **Platforms** | iPhone + iPad first; Android later from the same Flutter codebase |
| **Audience** | Casual outdoor players — families, friend groups, clubs |
| **Core promise** | Score a game faster and more reliably than pen and paper, and never argue about a rule again |
| **Distribution** | iOS App Store at launch, Google Play as a later release; free at launch, monetization planned (§7) |
| **Data** | On-device, local-first; no accounts, no tracking. One optional, anonymous backend for in-app feedback (`docs/FEEDBACK.md`). Cross-device sync is a v2 topic |

---

## 2. Game rules model

The rules below (digitized from the official Dutch rules sheet) drive the
scoring engine. Rules marked ⚙ are configurable house rules; the classic
values are always the defaults.

- 12 pins numbered 1–12 stand in a fixed diamond formation:

  ```
      7  9  8
     5 11 12 6
      3 10  4
       1  2
  ```

- Throwing distance is 3–4 m; the throwing stick is thrown underhand.
- **One pin knocked over → score = that pin's number.**
- **Multiple pins knocked over → score = the count of fallen pins.**
- A pin leaning on another pin or on the stick does **not** count as fallen.
- Fallen pins are stood back up **on the spot where they fell**, so the
  field spreads out as the game progresses.
- **Win by reaching exactly 50 points.** ⚙ target score: 25 / 50 / 100 / custom.
- **Overshooting the target drops the player back to 25.** ⚙ overshoot
  behavior: reset to 25 / reset to half the target / no penalty.
- **Three consecutive zero-score throws eliminate the player.** ⚙
  elimination on/off and miss limit configurable. If all other players are
  eliminated, the last remaining player wins.
- Played by individuals or teams, minimum two sides; turn order rotates
  one throw at a time.

---

## 3. Feature list

### 3.1 Onboarding — serves two audiences

Onboarding is a first-class feature. It must serve **(a) players who
already know the game and just want an easy-to-use scoring app** and
**(b) people who don't know the rules yet** — without making either sit
through the other's path.

1. **Welcome.** Brand moment: Viking illustration, app name, one-line
   pitch — and an immediate audience fork: **"I know the rules — start
   scoring"** vs **"Teach me the game"**. The fork *is* the skip mechanism
   for experienced players: one tap and they're in game setup.
2. **Rules section — skippable at every card.** "Skip" stays visible
   top-right throughout. Illustrated, swipeable rule cards (setup, scoring,
   overshoot, elimination) reuse the same pin-diagram component as the live
   game so the scoring screen feels familiar later. Cards are interactive
   where that teaches best (e.g. a "tap the pins that fell" mini-demo).
   Skipping loses nothing — the full rules panel (§3.6) is always reachable.
3. **Into setup.** Finishing or skipping the tour lands in game setup
   (§3.2), where players can be added or the defaults kept.
4. Onboarding never re-blocks the app; later launches open on Home, with
   **Quick start** (two numbered players, classic rules) as the primary
   action. The "Teach me the game" tour remains replayable from Settings.

### 3.2 Game setup

- **Quick start:** one tap on Home → 2 players, classic rules.
- **Players:** names are optional — "Add player" adds a numbered player,
  tapping the name renames it inline. Each player gets an identity color
  and an avatar disc with the initial or number. Recent players appear
  as chips for one-tap re-adding. A Viking avatar set is *(planned)*.
- **Team mode:** a switch; players alternate over two teams, a team pill
  on each player row moves them, "Swap teams" flips both, team names are
  editable.
- **House rules:** steppers for the target, the overshoot reset ("back
  to", 0 = no penalty) and the miss limit (0 = no elimination), with a
  Reset to classic. On phones they sit behind one row with a one-line
  summary. Active house rules appear as chips in the rules panel.
- **Turn order:** shuffle button or drag the avatar to reorder.
- **Summary bar:** the player count, the rules in one line and the Start
  button; it says what is missing when the game cannot start yet.
- **Rematch:** from any finished game — same players and rules, one tap.
- Layout: one column on phones, two columns from 720 pt (iPad,
  landscape) — see `docs/NEW_GAME_REDESIGN.md`.

### 3.3 Scoring tool (the core screen)

Two input modes, switchable in-game with a segmented control (the choice
is remembered):

- **Pin-tap mode (default).** The 12-pin diamond rendered large; tap the
  pins that fell, then the big **Confirm throw** button. The app computes
  the score by rule (1 pin = its number, n pins = n). Mis-taps are corrected
  by tapping again before confirming. An explicit **Miss** button makes a
  zero-score throw unambiguous.
- **Number pad mode.** A 0–12 grid of large buttons; one tap scores the throw.

Shared scoring UX (both input modes):

- **Active player card** front and center: name, avatar, current score, and
  the key helper line — *"Needs exactly 7 — pin 7, or knock 7 pins"*
  (computed points-to-target; the app's killer convenience).
- **Overshoot warning:** if the entered throw would bust, the confirm
  button turns amber and states "Overshoot → back to 25" before confirming.
- **Miss-streak indicator:** dots on each player card (●●○); at two misses
  the card warns "next miss eliminates" (only when elimination is on).
- **Undo,** multi-level. Editing any past throw from a per-player throw
  history is supported by the engine (`Game.editThrow`, everything
  downstream is recomputed); the screen for it is *(planned)*.
- **Score ticker animation** with optional haptics on score, overshoot,
  and win. Sound is *(planned)*.
- **Win moment:** full-screen celebration **personalized to the winning
  player** — their name, avatar, and color star in the animation (the
  Viking mascot cheers, leaf confetti falls over a scrim in the winner's
  color; a horn
  fanfare is *(planned)*) — followed by final standings, rematch and
  share buttons, and once in a while a short feedback question
  (`docs/FEEDBACK.md`). Tappable-through at any moment (§3.7).
- **Turn order strip** showing who's up next *(planned)*.
- **Screen-wake lock** during an active game (optional setting).
- **Outdoor-first ergonomics:** oversized touch targets (used at arm's
  length, in sunlight, sometimes with cold or gloved hands), high-contrast
  text, primary actions within thumb reach on iPhone.

### 3.4 iPad-specific

- Adaptive layout: on iPad the scoring controls and the live standings
  table sit side by side.
- **Scoreboard display mode:** a big, glanceable scoreboard (scores,
  who's up, miss dots) for propping the iPad up field-side; tap anywhere to
  return to scoring. Scoring on another device while the iPad shows the
  board is *(planned)* with sync.

### 3.5 Players, profiles & stats

- **Players:** name and color, stored locally; recent players are
  remembered (numbered players are not). Cross-device sync is deferred to
  v2, when a cross-platform sync backend can serve both iOS and Android.
- **Game history:** every finished game with date, players, rule set, and
  the full throw-by-throw log.
- **Stats per player:** games played, wins, win rate, average points per
  throw, most-hit pin, misses, overshoots, eliminations. Comebacks after
  an overshoot, the longest streak without a miss and head-to-head
  records are *(planned)*. Games can be deleted one by one or all at once.
- **Share card:** end-of-game summary rendered as an image for
  Messages/WhatsApp.
- **Resume:** an interrupted game (app killed, battery died) restores
  exactly, including undo history.

### 3.6 Rules panel — progressive disclosure everywhere

A slide-over panel openable from the game and setup screens (rules icon
in the bar; a sheet on iPhone, a centered sheet up to 640 pt wide on
iPad), and as a full screen from Settings — nobody ever leaves a game to
settle an argument. Built entirely on progressive disclosure so a user
never reads a wall of text to find one rule:

- Rules are **neatly categorized**: Setup & field · Throwing · Scoring ·
  Overshoot & reset · Misses & elimination · Winning · Teams. Each category
  is a collapsed row with an icon; the rule cards inside carry the
  illustrations.
- Tapping a category expands short, scannable rule cards — **one rule = one
  card**, at most two sentences plus a diagram. A second "detail"
  disclosure holds edge cases (e.g. leaning pins don't count).
- **Contextual deep links:** the miss-streak dots open the panel on the
  misses category, already expanded. The same link from the overshoot
  warning and the elimination banner is *(planned)*.
- **Search** field at the top of the panel for direct lookup.
- The panel shows the **active house rules** of the current game inline
  ("Target: 50 · Overshoot → 25 · Elimination: on"), so the reference
  always matches the game being played.
- The same categorized content powers the onboarding tour — one source of
  truth.

### 3.7 Motion design — fun, never in the way (Duolingo-inspired)

Animation is a core part of the app's charm, with one hard rule: **the user
never waits for an animation.**

- **Non-blocking.** Input stays live during any animation; the next tap
  interrupts or fast-forwards it. Score counters, card transitions, and the
  win celebration are all skippable by tapping anywhere. State updates
  instantly — motion decorates the change, it never delays it.
- **Celebrate in the gaps.** Big moments (personalized win, comeback from
  overshoot, escaping elimination, a streak of high throws) get reactions
  of the Viking mascot — played while players naturally pause, never
  gating the next action.
- **Micro-delight elsewhere.** Pins wobble and topple when tapped, score
  numbers roll like an odometer, miss dots pulse, avatars bounce on their
  turn. Each ≤ 400 ms and spring-based.
- **Character with restraint.** Mascot reactions are occasional and varied
  (Duolingo-style surprise), frequency-capped so they stay delightful.
- Respects **Reduce Motion** (crossfades replace movement); haptics mirror
  the key beats and can be disabled.
- Implementation: Flutter's Impeller renderer with state-driven implicit
  animations for UI motion; every duration goes through
  `KaatoMotion.resolve`, which collapses it to zero under Reduce Motion.
  The Viking mascot is code-drawn today (three poses); moving it to
  **Rive** character animation is *(planned)* — the `rive` package is
  already a dependency. Everything is interruptible by design: animation
  follows state, never timed waits.

### 3.8 Settings & help

- Appearance: theme (system, light, dark) and language override
  (defaults to the device language).
- During play: haptics and keep the screen awake.
- Learn: the rules panel (§3.6) and the replayable "Teach me the game"
  tour.
- Feedback: give feedback at any time (`docs/FEEDBACK.md`).
- About: open-source licenses, the design-system catalog
  (`docs/DESIGN_SYSTEM.md`), and the installed version and commit.
- House-rule defaults and sound are *(planned)*; the input mode is
  remembered from the game screen.
- Privacy: everything stays on the device except feedback someone chooses
  to send, which is anonymous. No accounts, no tracking.

### 3.9 Classic kubb mode — removed in 0.4.0

The app briefly also scored classic kubb (teams, baseline kubbs, a king).
It was removed when the app became **Kaato**: one game, done well.
Histories from those builds load without their classic-kubb matches.

---

## 4. Design system — "Scandinavian modern, Viking soul"

- **Palette (design tokens).** Light birchwood neutrals for surfaces
  (`#F5EFE6`–`#E8DCC8` range), deep forest greens for primary actions and
  brand (`#2F4A3C`, `#1E332A` range), a four-tone wood ramp (sanded oak
  `#DDB67A`, honey oak `#C68F43`, walnut `#5F3D25`, bark `#3B2616`; see
  `docs/WOOD_PALETTE.md`) for accents and pin illustrations, off-black ink
  for text. Full light **and** dark themes (dark = night-forest greens on
  deep charcoal-wood; filled controls use night greens with light labels,
  sanded oak is the accent for text and focus).
- **Typography.** Baloo 2 for the wordmark, headings and scores (tabular
  numerals so digits never jump); the platform sans (SF Pro on iOS) for
  body text.
- **Components.** Card-based forms (`lib/widgets/form_cards.dart`), one
  input recipe (`docs/INPUTS.md`), a track-and-tile segmented control,
  Liquid Glass chrome on iOS (`docs/LIQUID_GLASS.md`). Every token and
  component is documented live on the design-system page
  (`docs/DESIGN_SYSTEM.md`).
- **Illustration.** Code-drawn in Flutter, flat and minimal-line: the
  Viking mascot with throwing stick (three poses), the pin set, rule
  illustrations, wood grain. Home's hero is a hand-drawn SVG, Kaato at
  the workbench carving pins (`assets/character/`). Longship/rune flourishes, an avatar set and a
  layered app icon are *(planned)*. One consistent style — limited
  palette, chunky rounded linework, no gradients.
- **Materials.** Subtle wood-grain texture only on large brand surfaces
  (onboarding, win screen), never behind body text.
- All illustrations are **text-free** so they never need localization.

---

## 5. Localization — 10 languages, expansion-proof layout

Languages (the top countries where kubb/Mölkky is popular): **English,
Swedish, German, Dutch, French, Danish, Norwegian (Bokmål), Finnish,
Italian, Spanish.**

Interface rules so long translations (German and Finnish can run +35%)
never break the layout:

- No fixed-width text containers; buttons grow, labels wrap to two lines max.
- Icon + short-label pairs for primary actions instead of long verb phrases.
- Numerals and the pin diagram carry meaning wherever possible
  (language-neutral by construction).
- A pseudo-localization pass (+40% string inflation) in UI tests is
  *(planned)*; large-text layouts are covered by the adaptive components
  (e.g. segmented controls turn into wrapping chips above 1.3×).
- ARB string catalogs (`lib/l10n/app_*.arb`) with per-language plural rules
  via `flutter_localizations`/`intl`; dates and numbers via locale-aware
  formatters.

---

## 6. Platform & tech

**Flutter** was chosen over native SwiftUI for three explicit product goals:

1. **Android someday** — one codebase ships native iOS and Play Store
   builds; no rewrite when the Android release happens.
2. **Lots of animations** — Flutter's Impeller renderer is built for
   animation-heavy UIs, and **Rive** (Duolingo's character-animation tool)
   drives the Viking mascot with runtime state machines.
3. **Monetization someday** — the `in_app_purchase` package wraps StoreKit 2
   and Google Play Billing behind a single API.

Stack:

- **Flutter** 3.47.7 (stable), Dart 3.13; CI pins the exact version.
  Targets: iOS (App Store) and Android (pre-created, released later); a
  web build serves only as a development preview.
- **Riverpod** for state management, **go_router** for navigation,
  **shared_preferences** for settings, the active game and the history
  (JSON; a database such as Drift can replace it behind the same
  repository), **http** for the feedback backend.
- The scoring engine is a **pure Dart package**
  (`packages/scoring_engine`) with zero Flutter dependencies: a game is an
  immutable value replayed from its throw list, so rule variants,
  overshoot, elimination, undo, and throw-editing are pure functions that
  can never disagree with the UI — and it is exhaustively unit-tested.
- No accounts and no analytics or tracking SDKs. The only backend is the
  optional, anonymous feedback store on Supabase (`docs/FEEDBACK.md`).

### Repository layout

```
lib/
  main.dart, app.dart, router.dart
  theme/          tokens, palette, typography, light/dark themes, glass
  widgets/        shared components (form cards, segmented control, …)
  l10n/           ARB string catalogs, 10 languages
  features/
    onboarding/   welcome, audience fork, tour
    home/         quick start and resume
    setup/        players, teams, house rules
    game/         scoring screen, pin diagram, scoreboard, Live Activity
    rules/        categorized rules panel
    stats/        history & statistics
    settings/     settings, version
    feedback/     in-app feedback
    designsystem/ the living design-system catalog
packages/
  scoring_engine/ pure Dart rules engine + tests
ios/ android/ web/ platform shells
supabase/         feedback table migrations
tool/ios.sh       build and install on the owner's iPhone and iPad
docs/             current docs and dated reports (see docs/README.md)
```

---

## 7. Store readiness & monetization

- **iOS first:** privacy manifest *(planned)*; the App Privacy label
  declares the anonymous feedback as "Product Interaction / Other Usage
  Data, used for Analytics, not linked to you" (`docs/FEEDBACK.md`); no
  tracking, no ATT prompt. **Google Play later:** data-safety form equivalent; the
  Android shell is kept building from day one so the later release is a
  packaging exercise, not a port.
- **Monetization (someday, planned for now):** launch free. The likely
  model is a one-time "Pro" unlock (e.g. advanced stats, extra themes/
  avatar packs) via `in_app_purchase` — no ads, no subscriptions for a
  casual outdoor game. Until then, any pro-gated surface is kept behind a
  single feature-flag module so flipping monetization on later touches one
  place.
- **Accessibility:** large text scaling, screen-reader labels on pins and
  score events ("Pin 7 down — Jasper scores 7, needs 12") via Flutter
  Semantics, Reduce Motion respected, WCAG-AA contrast in both themes.
- App icon (Viking/pin motif), screenshots in all 10 locales, keywords,
  age rating 4+/PEGI 3.

---

## 8. Out of scope for v1 (v2 candidates)

Online multiplayer · watch apps · tournament brackets · cross-device
sync · web as a release target (the web build is a development preview
only) · classic kubb (shipped briefly, removed in 0.4.0 to keep the
app to one game). (The Live Activity, once a v2 candidate, shipped in v1
after all.) (Android is **not** out of scope — it's a planned later
release; the Android build is kept green from the start.)

---

## UX rationale (decision record)

- **Two input modes:** pin-tap prevents rule mistakes for casual groups
  (error prevention); the number pad serves experienced scorers
  (flexibility & efficiency) — the system absorbs rule complexity in
  pin-tap mode.
- **Fork-first onboarding:** rules teaching must never gate a group
  standing on a field ready to play; the experienced-player path is one tap
  (user control & freedom).
- **"Needs exactly X" helper** over a plain score list: mental arithmetic
  is the #1 pain of paper scoring (match the real world).
- **Instant-state, decorative motion:** every animation is interruptible
  and the underlying state updates immediately (Duolingo model) — delight
  never costs a wait.
- **Categorized rules over a rules page:** one rule = one card behind a
  category disclosure, deep-linked from in-game warnings — any disputed
  rule is found in two taps (recognition over recall).
- **One game, done well:** classic kubb shipped briefly and was removed in
  0.4.0, when the app became Kaato; a second rule set doubled every
  screen without helping the people who play number kubb.
- **Rejected:** camera/AR pin detection (unreliable outdoors, huge scope);
  watch-first scoring (deferred to v2); native SwiftUI (dropped once
  Android, monetization, and animation-heavy goals were added — Flutter
  serves all three from one codebase).
