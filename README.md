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

## Tests

```sh
flutter test                     # app widget tests
dart test -C packages/scoring_engine   # pure Dart rules engine tests
```

## Layout

- `lib/` — app code (theme tokens, router, feature folders, 10-language ARB catalogs)
- `packages/scoring_engine/` — pure Dart, Flutter-free rules engine (replay-based: undo/edit fall out for free)
- `SPEC.md` — the product spec this repo implements
