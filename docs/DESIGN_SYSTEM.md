# De designsystem-pagina als Storybook

`/designsystem` (ook via Settings) documenteert elk token en elk component
zoals een Storybook dat doet: per component een naam, het bronbestand, een
samenvatting, waar het gebruikt wordt, een props-tabel, de varianten op een
neutraal canvas en het toegankelijkheidscontract. Alles is de echte
productiewidget, live in het huidige thema.

## Opbouw

- `lib/features/designsystem/story.dart`: de documentatieblokken.
  - `Story(name, source, summary, usedIn, props, variants, a11y)`
  - `Prop(name, type, note)` en `Variant(label, child, note, background)`
  - `StoryCanvas`: het canvas (surface met zachte lijn) waarop een variant
    staat; `background` voor componenten die op een scrim of over hout
    horen.
  - `TokenRow(name, value, sample)`: één regel in de foundations.
- `lib/features/designsystem/design_system_screen.dart`: de catalogus.
  Secties in paginavolgorde, elk met een anker voor de springnavigatie:
  Color, Type, Space & shape, Motion, Chrome & glass, Buttons, Inputs,
  Cards & tiles, Players & teams, Status & numbers, Overlays & dialogs,
  Game pieces, Illustration, Behaviours.

Bovenaan: de themaschakelaar (alles eronder rendert live) en "Preview iOS
chrome", die de glascomponenten in de Chrome-sectie als op iOS tekent (de
glaswidgets lezen `Theme.platform`; knopvormen komen van het buildtarget en
veranderen niet mee).

## Wat gedocumenteerd is

Foundations: palet (incl. houtramp met gemeten contrast, lijnen, signalen,
spelerkleuren), typografie (stappen en begeleidende stijlen), spacing,
radius, randen, icoonmaten, alpha's, layoutbreedtes, tikminimum, motion.

Componenten, per sectie:

- **Chrome & glass**: KaatoAppBar; KaatoGlass, GlassGroup, GlassToolbar,
  BottomActionBar, glassIconButton, glassSheet; SectionHeader.
- **Buttons**: de Material-knoppen in de thema-hiërarchie (capsules op
  iOS); Overlay-knoppen; DashedAddButton.
- **Inputs**: TextField (alle staten); SelectField; SegmentedControl met
  een anatomie-overzicht (track, actieve tegel, label, icoon, segmenten);
  AdaptiveChoice (segmenten, chips bij grote tekst); chips; SwitchCard;
  StepperCard; ChoiceCard (beschikbaar, nu in geen scherm gebruikt);
  StarRating.
- **Cards & tiles**: FormCard en FormLabel; SettingCard; de
  Settings-tegels; ActiveSideCard en ColorDotName.
- **Players & teams**: AvatarCircle; TintPill; RecentChip; de spelerrij
  en de teamkaart (composities).
- **Status & numbers**: DotRow; RollingNumber; CelebrationBanner;
  SnackBar.
- **Overlays & dialogs**: confirmAdaptive; CelebrationScaffold;
  ConfettiBurst; ShareCard en showShareCardDialog.
- **Game pieces**: PinDiagram.
- **Illustration**: VikingMascot; WoodGrainBackground; de
  regelillustraties.
- **Behaviours**: KeepAwake; de LiquidGlass-gates; de paletfuncties
  (`on`, `woodAccent`, `woodGrain`, `danger`).

## Een component toevoegen

1. Bouw de widget in `lib/widgets/` (of in zijn feature als hij
   feature-specifiek is), alleen met tokens uit `lib/theme/`.
2. Voeg in de passende sectie van `design_system_screen.dart` een `Story`
   toe met minstens één `Variant` per visuele staat. Gebruik de echte
   widget, geen nabootsing.
3. Noem in `a11y` wat de semantiek belooft (label, rol, tikgrootte).
4. `test/design_system_test.dart` bouwt de hele catalogus in beide thema's,
   springt via de chips en controleert de a11y-richtlijnen; een story die
   niet bouwt, breekt de test.
