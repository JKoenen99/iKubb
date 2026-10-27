# Working agreements for Kaato

The single source of truth for how any agent (Claude Code, Codex,
Copilot, Cursor, Gemini, …) or person works in this repository.
`CLAUDE.md`, `GEMINI.md` and `.github/copilot-instructions.md` only point
here; change the rules in this file and nowhere else.

## The project in one paragraph

Kaato (Finnish for the felling, the knocked-over pin) is a Flutter app
that scores **number kubb**, the game with 12 numbered pins. It is the
only game the app plays; classic kubb was removed in 0.4.0, and the app
was called iKubb before that. iOS first, Android later from the same
code, a web build only as a development preview. Start with `README.md`;
`docs/README.md` says which docs describe the app as it is now.

## Branches: when to start a new one

`main` is what the owner can put on their iPhone and iPad at any time.
Every commit on `main` passes the checks below. Work happens on branches
and reaches `main` only after the owner has seen it.

**Start a new branch from `main` when the request is:**

1. A new feature or a new screen.
2. A redesign or a change to the visual language that touches many files.
3. A large refactor, rename or removal (the iKubb → Kaato change is the
   example).
4. Platform or release plumbing: bundle ID, signing, CI, dependency
   upgrades, store metadata.
5. An experiment the owner might reject.
6. Unrelated to what the current branch is about. Two unrelated asks in
   one message get two branches.
7. Any work after the current branch was merged. Never add new work to a
   merged branch.

**Stay on the current branch when the request is:**

- A fix or tweak to what this branch introduces, including feedback
  after testing it on a device.
- A test or CI fix for this branch.
- Docs, changelog or version entries for this branch's work.
- A small follow-up in the same area that should ship together with it.

**A bug on `main` while a branch is in progress:** fix it on
`fix/<topic>` from `main`, merge that first, then merge `main` into the
feature branch.

**Names:** `<type>/<topic>`, so the branch list reads as a list of what
is being worked on.

- `<type>` is the kind of work, from the list above: `feature` (new
  feature or screen), `design` (visual language, redesign), `fix` (a
  bug), `chore` (refactors, renames, platform, release, CI, dependencies,
  docs and working agreements).
- `<topic>` names the subject in two to four lowercase English words
  joined by hyphens: `feature/match-history`, `design/dark-theme-cards`,
  `fix/stepper-overflow`, `chore/branch-naming`.
- No dates, version numbers, ticket numbers, agent or tool names, or
  random suffixes. If the name is taken, pick a more specific topic.

**Cloud sessions with a generated branch.** A cloud session usually
starts on a branch with a generated name (`claude/trusting-clarke-g9spa7`
and the like). Do not do new work there. When the request needs a new
branch by the rules above, create `<type>/<topic>` from `main`, commit
and push there, and leave the generated branch untouched. This rule is
the owner's standing permission to push to that branch instead of the
designated one. Use the generated branch only when the owner asks for it
in that session.

**Existing branches keep their names.** Branches created before this
naming rule (including generated `claude/...` names) are finished and
merged as they are: do not rename, move or recreate them, and a
continuation of one of them stays on it.

**Say it every time.** Start each reply that changes code with one line:
which branch, and whether that is a continuation or a new branch, and why.

**Merging into `main`:** when the branch's work is done, propose the
merge once, and merge only when the owner says so (fast-forward or a pull
request, whichever they prefer; never open a pull request unasked). Delete
the branch after it is merged.

## Before every push

```sh
flutter analyze
dart format --set-exit-if-changed lib test packages
(cd packages/scoring_engine && dart test)
flutter test
```

For UI changes, also look at both themes and at the design-system page
(`/designsystem`, also under Settings). Never push red; never skip or
disable a test to get green.

## Versions and changelog

`version: MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`, shown at the bottom
of Settings together with the commit.

- Each branch bumps the version once: MINOR for features and design
  changes, PATCH for fixes, docs and chores that change the app. MAJOR
  becomes 1 with the first public release.
- BUILD goes up by one for every build the owner installs and is never
  reused (TestFlight and the App Store require that later).
- If two branches bumped to the same number, the one merged second takes
  the next number when it is merged.
- Every version gets an entry in `CHANGELOG.md`, in Dutch, written for
  the owner: what they will notice, not how it was built.

## Devices and the web preview

- The owner tests on their iPhone and iPad with `tool/ios.sh`, which
  builds the branch that is checked out on their Mac and installs it on
  every connected device. `tool/ios.sh --branch <name>` switches first.
  When a branch is ready to try, give the owner that exact command.
- The web preview (GitHub Pages) is published from every pushed branch;
  the most recent push wins. The commit at the bottom of Settings shows
  which one is live.
- Keep `ios/` free of changes that only exist on the Mac. Commit what
  Flutter or Xcode migrates (signing team, deployment target), or the
  next pull conflicts.

## Design system

The rules behind every screen. Details in the docs listed per item.

- **Tokens only.** Colors from `lib/theme/palette.dart`, everything else
  (spacing, radius, borders, alpha, motion, icon sizes, layout widths)
  from `lib/theme/tokens.dart`, text from `lib/theme/typography.dart`. No
  raw literals in screens; only code-drawn artwork keeps its geometry.
- **Components first.** Reuse what is in `lib/widgets/`: `form_cards.dart`
  (FormCard, SettingCard, SwitchCard, ChoiceCard, StepperCard,
  SelectField, DashedAddButton, AvatarCircle, TintPill, RecentChip),
  `segmented_control.dart` via `AdaptiveChoice`, `SectionHeader`,
  `settings_tiles.dart`, `KaatoAppBar`, the glass widgets in
  `lib/theme/glass.dart`. A new or changed component gets a `Story` on
  the design-system page in the same branch (`docs/DESIGN_SYSTEM.md`).
- **Inputs** follow one recipe: quiet fill, neutral line at rest, primary
  line on focus (`docs/INPUTS.md`). Pick-one choices use `AdaptiveChoice`
  (track-and-tile segmented control, chips at large text sizes).
- **Color roles:** forest greens are the brand and light-theme primary;
  the wood ramp (sanded oak, honey oak, walnut, bark) is for accents with
  fixed roles; dark-theme filled controls use the night greens through
  `primaryContainer` so their labels stay light (`docs/WOOD_PALETTE.md`).
  Foregrounds on colored fills come from `KaatoPalette.on(fill)`.
- **Liquid Glass** only for chrome on iOS (bars, toolbars, sheets), never
  for content, never glass on glass (`docs/LIQUID_GLASS.md`).
- **Accessibility is part of done:** WCAG 2.2 AA contrast (pinned in
  `test/palette_test.dart`), tap targets of at least 48 pt, a semantic
  label on every control, Reduce Motion through `KaatoMotion.resolve`.

## Copy and languages

- Ten locales (`lib/l10n/app_*.arb`); English is the template with
  `@` metadata. A new string goes into all ten files in the same commit;
  remove strings nobody uses.
- The game is *number kubb* in English and *nummerkubb* in Dutch (see the
  ARB files for the other languages). Players throw a *stick* at *pins*.
  User-facing copy says *player* or *team*, never *side*.
- Do not use "Mölkky" in the app: it is a registered trademark.
- The app name is **Kaato** everywhere; the Finnish inflection is
  "Kaatolla".

## Data and backend

- Storage keys in `shared_preferences` are brand-neutral and never
  renamed. Loading must tolerate records from older builds (skip what the
  app no longer plays, never crash on it).
- Feedback goes to Supabase (`docs/FEEDBACK.md`). The publishable key is
  public by design; Row Level Security limits it to inserts.
- Migrations in `supabase/migrations/` are append-only: never edit one
  that has been applied, add a new one.

## Commits and GitHub

- Commit messages, code and comments in English; explain why, not only
  what.
- No AI model names or IDs in commits, code or docs.
- No pull requests unless the owner asks for one.

## Docs

- Keep the current docs (listed in `docs/README.md`) true in the same
  branch as the change that affects them.
- Dated reports in `docs/` (audits, reviews, strategy) are history: do
  not rewrite them, add a note at the top when they are out of date.

## Language

The owner writes Dutch or English; answer in the language of their
message. Docs for the owner (`docs/`, changelog) are Dutch; code,
comments, commit messages and this file are English.
