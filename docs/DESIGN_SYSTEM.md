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

Componenten: IKubbAppBar; IKubbGlass, GlassGroup, GlassToolbar,
BottomActionBar, glassIconButton, glassSheet; SectionHeader; de Material-
knoppen in de thema-hiërarchie; Overlay-knoppen; DashedAddButton; TextField
(alle staten); SelectField; AdaptiveChoice (segment en chip-modus);
chips; SwitchCard; StepperCard; ChoiceCard; StarRating; FormCard en
FormLabel; SettingCard; de Settings-tegels; ActiveSideCard en
ColorDotName; AvatarCircle; TintPill; RecentChip; de spelerrij en
teamkaart (composities); DotRow; RollingNumber; CelebrationBanner;
SnackBar; confirmAdaptive; CelebrationScaffold; ConfettiBurst; ShareCard
en showShareCardDialog; KubbBlock, KubbKing, KubbBlockRow, AdvantageLine;
PinDiagram; VikingMascot; WoodGrainBackground; de regelillustraties;
KeepAwake; LiquidGlass-gates; de paletfuncties.

## Een component toevoegen

1. Bouw de widget in `lib/widgets/` (of in zijn feature als hij
   feature-specifiek is).
2. Voeg in de passende sectie van `design_system_screen.dart` een `Story`
   toe met minstens één `Variant` per visuele staat. Gebruik de echte
   widget, geen nabootsing.
3. Noem in `a11y` wat de semantiek belooft (label, rol, tikgrootte).
4. `test/design_system_test.dart` bouwt de hele catalogus in beide thema's,
   springt via de chips en controleert de a11y-richtlijnen; een story die
   niet bouwt, breekt de test.
