# Kaato

The number kubb scoreboard — Scandinavian modern, Viking soul.

A Flutter app (iOS first, Android later) that scores number kubb
("Scandinavisch kegelspel", the Mölkky-style game with 12 numbered pins),
teaches the rules, and keeps player stats. See [SPEC.md](SPEC.md) for the
full specification and feature list.

## The name

*Kaato* is Finnish for the felling: the knocked-over pin. Short, and easy
to say in English, French and Finnish. Until version 0.4.0 the app was
called iKubb and also scored classic kubb; it now does one game.

The GitHub repository is still named `iKubb`. Renaming it in GitHub
settings is safe: the web preview builds its base path from the
repository name, and GitHub redirects the old URLs.

## Branches

`main` is always installable; work happens on `feature/…`, `design/…`,
`fix/…` and `chore/…` branches and is merged after review. When to start
a branch and when not: [CLAUDE.md](CLAUDE.md).

## Getting started

Requires Flutter 3.47+ (stable); CI pins the exact version in
`.github/workflows/web-preview.yml`.

```sh
flutter pub get
flutter gen-l10n
flutter run                      # on a connected device or simulator
```

## Preview on iPad (or any browser)

Every push runs the **Web preview** GitHub Actions workflow, which builds the
app for the web and deploys it to GitHub Pages:

> https://jkoenen99.github.io/iKubb/

One-time setup: in the GitHub repo go to **Settings → Pages** and set
**Source** to **GitHub Actions** (the workflow also tries to enable this
automatically on its first run). Open the URL in Safari and use
*Share → Add to Home Screen* for an app-like fullscreen experience.
Note: a GitHub Pages site is publicly reachable by anyone with the URL.

The web build is a development preview only — releases ship as native
iOS/Android apps.

## In-app feedback (optional backend)

Players can rate the app (stars, tags, a comment) at the end of a game,
after the tour, and from Settings. Events are stored on the device as
portable JSON and, when a backend is configured, posted to Supabase.
Without the two defines below the app runs with the local outbox only.

```sh
flutter build ipa \
  --dart-define=SUPABASE_URL=https://cebkosufhtkddecfroij.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_qaavkaafBNirBzeW9k3toA_FOi_Dx-d
```

The publishable key is public by design (every build ships it) and Row
Level Security limits it to inserting feedback rows; reading needs your
dashboard login. The web preview workflow passes the same two values.

Schema, privacy model, and analysis queries: [docs/FEEDBACK.md](docs/FEEDBACK.md);
the table lives in `supabase/migrations/`.

## Tests

```sh
flutter test                     # app widget tests
dart test -C packages/scoring_engine   # pure Dart rules engine tests
```

## iOS look: Liquid Glass

On iOS the chrome follows Apple's Liquid Glass guidelines: transparent
navigation bars whose buttons float in glass, glass toolbars for the
primary actions, inset glass half sheets, capsule controls. Android and
web keep the Material look from the same widget tree. Rules, fallbacks
(Increase Contrast) and what stays native: [docs/LIQUID_GLASS.md](docs/LIQUID_GLASS.md).

## New game screen and form cards

The New game screen is card based: a two-column layout on tablets, one
column on phones, inline renaming, numbered players when names are
skipped, team cards, and steppers for the house rules. The same cards
(`lib/widgets/form_cards.dart`) build Settings and the `/designsystem`
page. Design notes: [docs/NEW_GAME_REDESIGN.md](docs/NEW_GAME_REDESIGN.md).

## Wood palette

Accents come from a four-tone wood ramp (sanded oak, honey oak, walnut,
bark), each tone placed where it passes WCAG AA, with theme-aware helpers
for icons and grain. Rationale and contrast table:
[docs/WOOD_PALETTE.md](docs/WOOD_PALETTE.md).

## Inputs and the design-system catalog

Every input follows one recipe (quiet fill, neutral line at rest, primary
line on focus): [docs/INPUTS.md](docs/INPUTS.md). The `/designsystem`
page documents every token and component Storybook-style, with props,
variants and accessibility notes, in both themes:
[docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md).

## Testing on your own iPhone and iPad

One-time Mac setup, then `tool/ios.sh` pulls, builds once and installs
on every connected iPhone and iPad. Settings shows the version and
commit on the device. Steps and versioning rules:
[docs/IOS_DEVICE_TESTING.md](docs/IOS_DEVICE_TESTING.md); release notes
in [CHANGELOG.md](CHANGELOG.md).

## Layout

- `lib/` — app code (theme tokens, router, feature folders, 10-language ARB catalogs)
- `packages/scoring_engine/` — pure Dart, Flutter-free rules engine (replay-based: undo/edit fall out for free)
- `SPEC.md` — the product spec this repo implements
