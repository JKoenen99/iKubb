# iKubb

The number kubb scoreboard — Scandinavian modern, Viking soul.

A Flutter app (iOS first, Android later) that scores number kubb
("Scandinavisch kegelspel", the Mölkky-style game with 12 numbered pins),
teaches the rules, and keeps player stats. See [SPEC.md](SPEC.md) for the
full specification and feature list.

## Getting started

Requires Flutter 3.44+ (stable).

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

## Tests

```sh
flutter test                     # app widget tests
dart test -C packages/scoring_engine   # pure Dart rules engine tests
```

## Layout

- `lib/` — app code (theme tokens, router, feature folders, 10-language ARB catalogs)
- `packages/scoring_engine/` — pure Dart, Flutter-free rules engine (replay-based: undo/edit fall out for free)
- `SPEC.md` — the product spec this repo implements
