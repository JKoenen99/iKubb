# iKubb — Number Kubb Scoreboard

**Specification & feature list — v1.0 (pre-implementation)**

A scoreboard app for **number kubb** ("Scandinavisch kegelspel", the
Mölkky-style game with 12 numbered pins). It replaces pen-and-paper scoring
with a fast, mistake-proof scoring tool, teaches the rules to new players,
and keeps long-term player statistics. Scandinavian modern design with
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
| **Data** | On-device, local-first; no accounts, no tracking (cross-device sync is a v2 topic) |

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
3. **Game setup section — skippable.** A brief intro to setup, then the
   real setup flow (§3.2). Skipping jumps straight into a quick-start game
   with classic rules and generic player names ("Player 1/2") that can be
   renamed mid-game.
4. Onboarding never re-blocks the app; later launches open on Home. The
   "Teach me the game" tour remains replayable from the rules panel.

### 3.2 Game setup

- **Quick start:** one tap → 2 players, classic rules.
- **Player picker:** recent players shown first; add a new player inline
  (name + Viking vector avatar + color).
- **Team mode:** drag players into teams, auto-balance suggestion, team names.
- **House rules:** a collapsed "Classic rules" summary chip; expanding it
  reveals the ⚙ options from §2. Active house rules appear as chips in the
  game-screen header so everyone knows what's in play.
- **Turn order:** shuffle button or manual drag to reorder.
- **Rematch:** from any finished game — same players and rules, one tap.

### 3.3 Scoring tool (the core screen)

Two input modes, switchable in-game via a toggle (preference persisted):

- **Pin-tap mode (default).** The 12-pin diamond rendered large; tap the
  pins that fell, then the big **Confirm throw** button. The app computes
  the score by rule (1 pin = its number, n pins = n). Mis-taps are corrected
  by tapping again before confirming. An explicit **Miss** button makes a
  zero-score throw unambiguous.
- **Number pad mode.** A 0–12 grid of large buttons; one tap scores the throw.

Shared scoring UX (both modes):

- **Active player card** front and center: name, avatar, current score, and
  the key helper line — *"Needs exactly 7 — pin 7, or knock 7 pins"*
  (computed points-to-target; the app's killer convenience).
- **Overshoot warning:** if the entered throw would bust, the confirm
  button turns amber and states "Overshoot → back to 25" before confirming.
- **Miss-streak indicator:** dots on each player card (●●○); at two misses
  the card warns "next miss eliminates" (only when elimination is on).
- **Undo,** multi-level, plus a tappable per-player throw history to edit
  any past throw; the engine recomputes everything downstream.
- **Score ticker animation** with optional haptics/sound on score,
  overshoot, and win.
- **Win moment:** full-screen celebration **personalized to the winning
  player** — their name, avatar, and color star in the animation (the
  Viking mascot hoists the winner's avatar; horn fanfare; leaf-and-rune
  confetti) — followed by final standings, per-game stats, rematch and
  share buttons. Tappable-through at any moment (§3.7).
- **Turn order strip** showing who's up next.
- **Screen-wake lock** during an active game (optional setting).
- **Outdoor-first ergonomics:** oversized touch targets (used at arm's
  length, in sunlight, sometimes with cold or gloved hands), high-contrast
  text, primary actions within thumb reach on iPhone.

### 3.4 iPad-specific

- Adaptive layout: on iPad the scoring controls and the live standings
  table sit side by side.
- **Scoreboard display mode:** a big, glanceable landscape scoreboard
  (scores, who's up, miss dots) for propping the iPad up field-side —
  scoring happens on an iPhone, or on the iPad itself via a floating input
  panel.

### 3.5 Players, profiles & stats

- **Player profiles:** name, Viking avatar, color — stored locally
  (local-first database); cross-device sync is deferred to v2, when a
  cross-platform sync backend can serve both iOS and Android.
- **Game history:** every finished game with date, players, rule set, and
  the full throw-by-throw log.
- **Stats per player:** games played, win rate, average points per throw,
  most-hit pin, eliminations, comebacks-after-overshoot, longest streak
  without a miss, head-to-head records.
- **Share card:** end-of-game summary rendered as an image for
  Messages/WhatsApp.
- **Resume:** an interrupted game (app killed, battery died) restores
  exactly, including undo history.

### 3.6 Rules panel — progressive disclosure everywhere

A slide-over panel openable from **every** screen (persistent rules icon;
sheet on iPhone, sidebar/popover on iPad) — nobody ever leaves a game to
settle an argument. Built entirely on progressive disclosure so a user
never reads a wall of text to find one rule:

- Rules are **neatly categorized**: Setup & field · Throwing · Scoring ·
  Overshoot & reset · Misses & elimination · Winning · Teams. Each category
  is a collapsed row with a one-line summary and a tiny illustration.
- Tapping a category expands short, scannable rule cards — **one rule = one
  card**, at most two sentences plus a diagram. A second "detail"
  disclosure holds edge cases (e.g. leaning pins don't count).
- **Contextual deep links:** the overshoot warning, miss-streak indicator,
  and elimination banner each link straight to their exact rule card.
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
  overshoot, escaping elimination, a streak of high throws) get character
  animations of the Viking mascot — played while players naturally pause,
  never gating the next action.
- **Micro-delight elsewhere.** Pins wobble and topple when tapped, score
  numbers roll like an odometer, miss dots pulse, avatars bounce on their
  turn. Each ≤ 400 ms and spring-based.
- **Character with restraint.** Mascot reactions are occasional and varied
  (Duolingo-style surprise), frequency-capped so they stay delightful.
- Respects **Reduce Motion** (crossfades replace movement); haptics mirror
  the key beats and can be disabled.
- Implementation: Flutter's Impeller renderer with state-driven implicit/
  spring animations for UI motion, and **Rive** for the Viking mascot's
  character animations — the same tool Duolingo uses for its characters,
  with tiny file sizes and runtime state machines. Everything is
  interruptible by design: animation follows state, never timed waits.

### 3.8 Settings & help

- Rules panel (§3.6) and the replayable "Teach me the game" tour.
- House-rule defaults, sound/haptics, screen-wake, default input mode.
- Language override (defaults to device language), iCloud sync toggle.
- Privacy: everything on-device or in the user's private iCloud — no
  accounts, no tracking.

---

## 4. Design system — "Scandinavian modern, Viking soul"

- **Palette (design tokens).** Light birchwood neutrals for surfaces
  (`#F5EFE6`–`#E8DCC8` range), deep forest greens for primary actions and
  brand (`#2F4A3C`, `#1E332A` range), warm oak/walnut tones for accents and
  pin illustrations, off-black ink for text. Full light **and** dark themes
  (dark = night-forest greens on deep charcoal-wood).
- **Typography.** Clean humanist sans (SF Pro; rounded display cuts for
  scores); scores use large tabular-lining numerals.
- **Illustration.** A flat, minimal-line Viking vector set built during
  implementation as SwiftUI-native/SVG assets: friendly Viking mascot with
  throwing stick, pin set, longship/rune flourishes for empty states, win
  screen and onboarding art, avatar set, app icon. One consistent style —
  limited palette, chunky rounded linework, no gradients.
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
- A pseudo-localization pass (+40% string inflation) runs in UI tests.
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

- **Flutter** (stable channel, currently 3.44), Dart 3.12. Targets: iOS
  (App Store) and Android (pre-created, released later).
- **Riverpod** for state management, **go_router** for navigation,
  **Rive** for character animation, **shared_preferences** for lightweight
  settings; a local-first database (e.g. Drift) is added with the
  profiles/history feature.
- The scoring engine is a **pure Dart package**
  (`packages/scoring_engine`) with zero Flutter dependencies: a game is an
  immutable value replayed from its throw list, so rule variants,
  overshoot, elimination, undo, and throw-editing are pure functions that
  can never disagree with the UI — and it is exhaustively unit-tested.
- No backend, no accounts, no analytics/tracking SDKs.

### Repository layout

```
lib/
  main.dart, app.dart, router.dart
  theme/          design tokens (palette.dart) + light/dark themes
  l10n/           ARB string catalogs, 10 languages
  features/
    onboarding/   welcome + audience fork
    setup/        players, teams, house rules
    game/         scoring screen, pin diagram, game controller
    rules/        categorized rules panel
    stats/        history & statistics
packages/
  scoring_engine/ pure Dart rules engine + tests
ios/ android/     platform shells
```

---

## 7. Store readiness & monetization

- **iOS first:** privacy manifest, "Data Not Collected" nutrition label, no
  tracking/ATT. **Google Play later:** data-safety form equivalent; the
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

Online multiplayer · watch apps · widgets/Live Activities · tournament
brackets · classic kubb (block-throwing variant) rule set · cross-device
sync · web. (Android is **not** out of scope — it's a planned later
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
- **Rejected:** camera/AR pin detection (unreliable outdoors, huge scope);
  watch-first scoring (deferred to v2); native SwiftUI (dropped once
  Android, monetization, and animation-heavy goals were added — Flutter +
  Rive serves all three from one codebase).
