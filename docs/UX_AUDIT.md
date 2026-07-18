# UX Audit: iKubb

**Date:** 2026-07-18 · **Artefacts:** 11 screenshots of the current web build
(iPhone 390pt light + dark, iPad 1180pt) captured headlessly per route, plus
source review · **Scope:** brand awareness, emotional design, overall UX ·
**Platform:** iOS/iPadOS (audited via the web preview build)

> Screenshot caveat: the sandboxed capture environment blocks the runtime
> font CDN, so text is missing from the captures. Composition, color, and
> iconography are audited from the images; text-dependent judgements come
> from source review. The missing text itself surfaced finding #2.

## Executive summary

The app's foundations are genuinely strong: the flows are complete and
tested, the interaction design honors the spec's motion rules, and the
mascot gives the brand a face. But today the brand lives only at the
bookends (onboarding and the win screen) while the screen players stare at
for 30+ minutes — the game screen — is functionally excellent and visually
generic. One real usability defect (player-color collision with brand
surfaces) and one platform risk (CDN-fetched fonts) should be fixed first.

**Severity counts:** 0 Critical · 3 High · 4 Medium · 3 Low.

**Scores against the stated goals**

| Dimension | Score | One-line verdict |
|---|---|---|
| Brand awareness | 5/10 | Palette and mascot are right; typography, iconography, and the core screen don't carry the brand |
| Emotion | 6/10 | Strong personalized win moment; the mid-game journey is silent — no mascot reactions, no sound |
| Overall UX | 7.5/10 | Complete, mistake-proof flows with progressive disclosure; deductions for color collision, icon semantics, discoverability |

## Method and lenses

Nielsen's 10 heuristics (primary), Laws of UX (Fitts, Hick, Von Restorff,
Peak-End, Aesthetic-Usability), Gestalt/Norman for the interaction layer, a
WCAG skim for contrast, and the persuasion/onboarding lens for the welcome
fork — matching the stated goals (brand, emotion, overall UX).

## What's working

- **The mascot has real charm** — friendly, on-palette, text-free, and it
  anchors onboarding, the win moment, empty states, and the scoreboard
  winner state.
- **Palette discipline**: birch surfaces, forest primaries, oak accents
  read quietly Scandinavian in both themes; nothing garish.
- **The pin diamond is the brand's best asset** — instantly recognizable,
  reused across scoring, tour, and rules (consistency, Jakob's law).
- **Motion follows the spec's hard rule**: state first, decoration second,
  everything interruptible — verified by tests, not just intention.
- **Progressive disclosure done properly**: rules categories → cards →
  edge-case details; house rules behind a summary chip; deep links from
  warnings.
- **Outdoor ergonomics**: oversized targets, bottom-reachable actions,
  "needs exactly X" helper killing the mental arithmetic.

## Findings

### 1. Player colors collide with brand surfaces: High
- **Where:** game screen standings (both themes), scoreboard active
  highlight (annotated on `game_phone` and `scoreboard_ipad`)
- **Heuristic:** Nielsen #1 Visibility of system status; WCAG non-text
  contrast
- **Observation:** the default player palette starts with the same forest
  green used for the active-card background and the scoreboard's dark
  green field. Player 1's identity dot is invisible on their own active
  card, and the scoreboard's "who's up" tint (their color at 35% over
  forest-deep) is nearly indistinguishable across the field.
- **Why it matters:** color is the player-identity system; when it
  disappears on exactly the highlighted element, the "whose turn" signal —
  the app's most-read status — weakens.
- **Recommendation:** remove brand-surface hues (forest, pine) from
  `playerColors`; use a distinct identity set (oak, amber, berry,
  blue-grey, indigo, plus 3 new hues) and add a light outline to identity
  dots so they read on any surface.

### 2. No brand typography — and fonts load from a CDN at runtime: High
- **Where:** every screen; wordmark on onboarding (annotated)
- **Heuristic:** Aesthetic-Usability; reliability (offline PWA breaks)
- **Observation:** all text is default Roboto (web) fetched from
  fonts.gstatic.com at runtime — in this audit's blocked-network capture
  the app rendered with no text at all. The spec (§4) promises rounded
  display cuts and tabular numerals as part of the brand.
- **Why it matters:** typography is the cheapest, most pervasive brand
  carrier; today the app is typographically anonymous, and any offline or
  filtered-network use loses text entirely.
- **Recommendation:** bundle an OFL-licensed rounded display family (e.g.
  Nunito or Baloo 2) as an asset font for the wordmark, scores, and
  headings (tabular numerals for scores); keep the platform font for body
  text. Bundling also fixes offline.

### 3. The game screen — the longest-exposure surface — carries almost no brand: High
- **Where:** game screen pin diagram and chrome (annotated)
- **Heuristic:** Aesthetic-Usability; brand goal ("wooden tones, Viking
  soul")
- **Observation:** pins are flat birch circles with a green ring — they
  read as generic radio buttons, not wooden pins; in dark mode they become
  near-black voids. There is no wood tone, no texture, no illustration
  anywhere on the screen; the app bar says "iKubb" in plain type.
- **Why it matters:** players spend ~95% of session time here; brand
  memory forms on this screen or not at all.
- **Recommendation:** redraw pins as mini wooden pins (oak fill, walnut
  rim, painted number disc, subtle grain stroke) with a fallen state that
  keeps the wood in dark mode; add a restrained birch-texture header band
  or field backdrop behind the diagram (never behind text, per spec §4);
  replace the app-bar text with a small logotype + mascot-head mark.

### 4. Game app bar: five generic icons, two with wrong semantics: Medium
- **Where:** game screen top bar (annotated)
- **Heuristic:** Nielsen #6 Recognition over recall; Hick's law
- **Observation:** dialpad, cast-to-TV, help, undo, restart — five
  same-weight Material glyphs. "Cast" universally means streaming, not
  scoreboard mode; "dialpad" suggests a phone keypad.
- **Why it matters:** the two most distinctive features (scoreboard mode,
  input switch) hide behind misleading icons; five choices tax scanning.
- **Recommendation:** keep undo + rules visible; move restart and
  scoreboard into an overflow menu or give scoreboard a custom
  big-numbers icon; make the input switch a labeled segmented control
  inside the input area where the mode change actually happens.

### 5. Onboarding and tour composition: dead space and equal-weight fork: Medium
- **Where:** welcome and tour cards (annotated on `onboarding_phone`)
- **Heuristic:** Von Restorff (primary action should pop); visual
  hierarchy
- **Observation:** ~40% of the welcome screen is empty above the mascot;
  the two fork buttons are equal-size full-width slabs differing only in
  fill color. Tour cards float content at the top with a large hollow
  middle.
- **Why it matters:** the first screen sets brand expectations, and the
  fork is the routing moment for the two audiences the spec names.
- **Recommendation:** compose the welcome as one vertical rhythm (mascot +
  wordmark + tagline as a unit, fork anchored below); differentiate the
  fork — filled primary "Start scoring" vs outlined "Teach me" with a
  school icon; vertically center tour-card content.

### 6. Miss dots appear before any miss, and their tap affordance is hidden: Medium
- **Where:** player cards, scoreboard (annotated both)
- **Heuristic:** Nielsen #8 Minimalist design; affordance (Norman)
- **Observation:** three grey dots render on every card from throw zero;
  nothing signals they're tappable (they deep-link to the elimination
  rule). On the iPad scoreboard they are too small to read across a field.
- **Why it matters:** pre-miss dots are noise until the third game when
  their meaning is learned; the deep link is undiscoverable.
- **Recommendation:** fade dots in on first miss; pair with a subtle ⓘ on
  the "next miss eliminates" warning state; scale dots up on the
  scoreboard.

### 7. Peak-end asymmetry — strong finale, silent journey: Medium
- **Where:** whole game flow
- **Heuristic:** Peak-End rule; spec §3.7 "celebrate in the gaps"
- **Observation:** the win moment is excellent (personal color, mascot,
  confetti, haptics), but between throw one and the win the app never
  emotes: no mascot reactions to overshoots, eliminations, comebacks, or
  streaks; no sound at all.
- **Why it matters:** emotion score hinges on mid-game peaks; the spec
  explicitly calls for frequency-capped character moments.
- **Recommendation:** add 2–3 frequency-capped mascot reactions (corner
  pop-in ≤1.5s, interruptible): overshoot wince, escape-elimination
  relief, high-streak cheer; optional horn/wood sound pack behind a
  setting.

### 8. Dark theme loses the wood entirely: Low
- **Where:** dark game screen
- **Observation/Recommendation:** pins become near-black circles; solved
  by finding #3's wooden pin treatment (oak/walnut fills persist in dark).

### 9. Rules categories promised "tiny illustrations", ship black glyphs: Low
- **Where:** rules screen/panel rows
- **Recommendation:** tint category icons forest/oak now; add mini
  illustrations when the asset set grows (spec §3.6).

### 10. Web preview ships Flutter-default favicon, title, and white splash: Low
- **Where:** browser tab / PWA install of the preview
- **Recommendation:** birch-toned favicon with the mascot head, `iKubb`
  title, birch background + mascot in the index.html splash. Low effort,
  first brand touchpoint for every tester.

## Annotated screenshots

- `docs/audit/game_phone_annotated.png` — findings 1, 3, 4, 6
- `docs/audit/onboarding_phone_annotated.png` — findings 2, 5
- `docs/audit/scoreboard_ipad_annotated.png` — findings 1, 6

## Prioritised improvement plan

**Phase 1 — Correctness & quick wins (small, do first)**
1. New player-identity palette excluding brand surface hues + outlined
   identity dots (#1)
2. Game app bar cleanup: 3 visible actions, correct icons, segmented input
   toggle (#4)
3. Miss-dot behavior: appear on first miss, larger on scoreboard (#6)
4. Web preview branding: favicon, title, splash (#10)

**Phase 2 — Brand core (the identity investment)**
5. Bundle rounded display font; apply to wordmark, headings, scores with
   tabular numerals; fixes offline too (#2)
6. Wooden pin redesign + subtle birch texture accents, dark-mode variants,
   app-bar logotype (#3, #8)

**Phase 3 — Emotion & polish**
7. Frequency-capped mascot reactions mid-game; optional sound pack behind
   a setting (#7)
8. Onboarding/tour composition pass with the new type + fork hierarchy (#5)
9. Tinted rules-category icons (#9)

Each phase is shippable on its own; Phase 1 is bug-fix-sized, Phase 2 is
where brand-awareness score moves from 5 to ~8, Phase 3 moves emotion from
6 to ~8.

## Appendix: frameworks referenced

Nielsen's 10 usability heuristics; Laws of UX (Fitts, Hick, Von Restorff,
Peak-End, Aesthetic-Usability); Norman's affordances; Gestalt grouping;
WCAG 2.2 contrast (spot checks); Fogg/persuasion lens on the onboarding
fork.
