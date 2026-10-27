# Working agreements for Kaato

Kaato is a Flutter app (number kubb scoreboard). Read `README.md` for the
layout and `docs/IOS_DEVICE_TESTING.md` for how the owner tests on devices.

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

**Names:** `feature/<topic>`, `design/<topic>`, `fix/<topic>`,
`chore/<topic>`. A cloud session may come with a designated `claude/...`
branch; use it for that session's topic and say so.

**Say it every time.** Start each reply that changes code with one line:
which branch, and whether that is a continuation or a new branch, and why.

**Merging into `main`:** when the branch's work is done, propose the
merge once, and merge only when the owner says so (fast-forward or a pull
request, whichever they prefer; never open a pull request unasked). Delete
the branch after it is merged.

## Before every push

- `flutter analyze`, `dart format --set-exit-if-changed lib test packages`
- `cd packages/scoring_engine && dart test`, then `flutter test`
- For UI changes, also check both themes and the design-system page.

## Versions

`version: MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`, shown at the bottom
of Settings with the commit.

- Each branch bumps the version once: MINOR for features and design
  changes, PATCH for fixes. BUILD goes up by one for every build the owner
  installs.
- If two branches bumped to the same number, the one merged second takes
  the next number when it is merged.
- Every version gets an entry in `CHANGELOG.md`, in Dutch.

## Devices and preview

- The owner tests on their iPhone and iPad with `tool/ios.sh`, which
  builds the branch that is checked out on their Mac.
  `tool/ios.sh --branch <name>` switches first; tell the owner which
  command to run when a branch is ready to try.
- The web preview is published from every pushed branch; the most recent
  push wins. The commit at the bottom of Settings shows which one it is.
- Keep `ios/` free of changes that only exist on the Mac: commit what
  Flutter or Xcode migrates (signing team, deployment target), or the
  next pull conflicts.

## Language

The owner writes Dutch or English; answer in the language of their
message. Docs for the owner (`docs/`, changelog) are Dutch; code,
comments and commit messages are English.
