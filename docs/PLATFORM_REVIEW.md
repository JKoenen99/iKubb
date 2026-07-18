# Platform review: Apple HIG · iOS patterns · Android/Material patterns

**Date:** 2026-07-18 · **Scope:** full app, source-level review of every
screen plus the iOS/Android platform shells. Items marked **FIXED** were
corrected as part of this review; **PASS** already conformed; **TO VERIFY**
needs a real device or store submission to confirm; **DEFERRED** is
tracked backlog.

## Summary

The Flutter layer was in good shape (adaptive back buttons and page
transitions come free; touch targets, safe areas, and localization were
already right). The real gaps were in the **platform shells** — both
stores would have shipped with Flutter's default icon, a white launch
screen, and a lowercase "ikubb" name — plus four in-app pattern issues,
all fixed: platform-adaptive icons and switches, a missing destructive-
action confirmation, and share/overflow glyph conventions.

## Apple HIG

| Area | Status | Notes |
|---|---|---|
| App icon | **FIXED** | Was Flutter's default. Brand mark now generated for all 15 catalog entries, opaque RGB (HIG: no alpha in app icons). |
| Launch screen | **FIXED** | Was white; now birch `#F5EFE6` to blend into the app's first frame (HIG: launch should resemble the first screen). |
| Display name | **FIXED** | `Ikubb` → `iKubb` (CFBundleDisplayName + CFBundleName). |
| Navigation & back | **PASS** | MaterialPageRoute is platform-adaptive: iOS gets Cupertino slide transitions and the edge-swipe back gesture; `BackButton` renders the iOS chevron. No screen is a dead end (home fallback leading everywhere). |
| Destructive actions | **FIXED** | "New game" mid-game silently discarded the running game. Now `AlertDialog.adaptive` (renders as a Cupertino alert on iOS) asks first; empty/finished games reset silently. |
| Share | **FIXED/PASS** | Uses the system share sheet (HIG requirement); glyph now `Icons.adaptive.share` (iOS square-and-arrow, Android share nodes). |
| Overflow menu | **FIXED** | `Icons.adaptive.more` (ellipsis on iOS, kebab on Android). Labeled menu rows, not bare icons. |
| Switches | **FIXED** | Settings and team-mode toggles use `SwitchListTile.adaptive` → real UISwitch styling on iOS. |
| Touch targets | **PASS** | Everything ≥ 44 pt (pins 60, primary buttons 56, pad keys 68×60); `materialTapTargetSize: padded` baked into the theme. |
| Haptics | **PASS** | `HapticFeedback.light/heavyImpact` map to `UIImpactFeedbackGenerator`; user-disableable per HIG. |
| Safe areas | **PASS** | `SafeArea` on every screen incl. the landscape scoreboard (home-indicator + notch respected). |
| Typography | **PASS** | Body text stays on the platform font (SF on iOS); the brand font is display-only, weights ≥ regular, WCAG-AA colors. |
| Reduce Motion | **PASS** | Confetti, mascot poses, and reactions all check `MediaQuery.disableAnimationsOf`. |
| Localization | **PASS/FIXED** | 10 languages; `CFBundleLocalizations` declared (fixed earlier this session); language override in settings. |
| Dynamic Type | **TO VERIFY** | Text scales with the system setting (Flutter default); layouts use wrapping/`FittedBox`, but XL sizes should be eyeballed on device before submission. |
| VoiceOver | **TO VERIFY** | Pins and toggles carry localized semantics; full traversal order needs an on-device pass. |

## Android / Material

| Area | Status | Notes |
|---|---|---|
| Launcher icon | **FIXED** | Brand mark generated for all five densities (mdpi–xxxhdpi). |
| Adaptive + themed icons | **DEFERRED** | Legacy square icons ship now; proper adaptive layers (foreground/background/monochrome for Android 13 themed icons) belong in the Play-release pass. |
| App label | **FIXED** | `ikubb` → `iKubb`. |
| Launch/splash | **FIXED** | `launch_background.xml` (both API variants) now birch instead of white; pairs with the Android 12+ splash API defaults. |
| Material 3 | **PASS** | M3 components throughout (SegmentedButton, FilledButton, chips, expansion tiles); dynamic-color is intentionally not used — the brand palette is the identity. |
| System back | **PASS** | Root screens exit the app (platform convention); pushed screens pop; predictive-back works through Flutter's default integration. |
| Share sheet | **PASS** | System sheet via share_plus. |
| Dark theme | **PASS** | Full dark palette, follows the system setting. |
| Edge-to-edge | **TO VERIFY** | Flutter defaults are fine today; Android 15 enforced edge-to-edge should be sanity-checked when the Play build is made. |

## Cross-platform consistency decisions (intentional)

- **One visual identity, adaptive behavior**: the app keeps its
  Scandinavian brand look on both platforms (allowed and encouraged by
  both guidelines) while *behavioral* primitives — alerts, switches,
  share/overflow glyphs, transitions, back gestures — follow each
  platform via `.adaptive` variants.
- **No Cupertino screen rewrites**: full Cupertino counterparts of every
  screen would double the UI surface for marginal gain in a game-tool
  context; adaptive primitives cover the moments users actually notice.

## Remaining before store submission

1. On-device pass: Dynamic Type XL, VoiceOver/TalkBack traversal,
   Android 15 edge-to-edge.
2. Android adaptive/monochrome icon layers.
3. iOS build + signing pipeline (macOS CI), Play packaging.
