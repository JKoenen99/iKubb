# Houtpalet: één materiaal, vier tinten

Het oude accentpaar (oak `#B98A4E`, walnut `#6B4A2F`) deed te veel tegelijk:
oak was merkaccent, dark-theme primary én spelerkleur 1, en beide tinten
stonden los van elkaar (oak neigde naar mosterd, walnut was grijzig). Op
donkere oppervlakken viel walnut weg (2,2:1) en op oak was de lichte
avatar-initiaal onleesbaar (2,7:1).

Het nieuwe palet is een doorlopende houtramp: één houtsoort onder één
lichtbron. De tint loopt van 37° (licht) naar 27° (donker) en de
verzadiging neemt toe naarmate het hout donkerder wordt, zoals bij echt
eiken en walnoot. Elke tint heeft één rol, en die rol is gekozen op de
plek waar hij WCAG AA haalt.

| Token | Hex | Naam | Rol | Contrast |
|---|---|---|---|---|
| `oakLight` | `#DDB67A` | geschuurd eiken | accent op donkere oppervlakken: tekst, randen, focus (dark-theme `primary`); highlights | 8,7:1 op charcoal |
| `oak` | `#C68F43` | honingeiken | light-theme accentvulling (`secondary`), staande pins en kubbs, spelerkleur 1 | ink erop 5,7:1; 4,7:1 op forestDeep |
| `walnut` | `#5F3D25` | walnoot | accent op lichte oppervlakken, Team A, gevelde pins, lijnwerk | 8,4:1 op birchLight; birch-tekst erop 8,4:1 |
| `bark` | `#3B2616` | schors | diepste hout: randen, knoesten, pin-randen | 5,4:1 tegen oak |

`birchLight` en `birch` blijven de lichte uiteinden van dezelfde plank.

## Helpers (`lib/theme/palette.dart`)

- `IKubbPalette.woodAccent(brightness)`: walnut op licht, geschuurd eiken
  op donker. Voor houten iconen, dots en lijnen die direct op een
  oppervlak staan (pijlen en trofeeën in de regels, batons, het
  statistieken-icoon).
- `IKubbPalette.woodGrain(brightness)`: de nerfkleur op Home en
  onboarding; voorheen verdween de walnoot-nerf in het donkere thema.
- `IKubbPalette.on(fill)`: ink op lichte vullingen (oak, amber,
  geschuurd eiken), birch op donkere. Gebruikt door `AvatarCircle` en
  `TintPill`, zodat elke spelerkleur een AA-initiaal krijgt. Copper is
  daarvoor een stap dieper gezet (`#A85420`, 4,7:1).

## Wat er zichtbaar verandert

- **Dark theme**: geschuurd eiken is het accent voor tekst, randen en focus
  (geselecteerde kaartrand, tekstknoppen, cursor). Gevulde knoppen, het
  gekozen segment, de actieve standenkaart, chips en schakelaars gebruiken
  de nachtgroenen `pineNight` (`#4F7260`) en `mossNight` (`#3A5244`) met
  berken-tekst, zodat labels in het donker licht blijven (HIG- en
  Airbnb-conventie). In code: `primaryContainer`/`secondaryContainer`, die
  in het lichte thema gelijk zijn aan forest en oak.
- **Pins en kubbs**: staande blokken honingeiken met een schorsrand, gevelde
  blokken walnoot met een berkenrand. Het contrast tussen staand en geveld
  is groter dan voorheen.
- **Regelillustraties**: pijlen, trofeeën, de stok en de batons volgen het
  thema (`woodAccent`), in het donker dus geschuurd eiken.
- **Avatars en teampillen**: donkere initiaal op lichte vullingen.
- **Live Activity** (`ios/LiveScoreWidget`): oak bijgewerkt naar de nieuwe
  waarde.

## Voorbeeld

`docs/wood_palette_preview.svg` zet oud en nieuw naast elkaar in beide
thema's, met de gemeten contrastwaarden per toepassing.

## Bewaking

`test/palette_test.dart` legt elke contrastbelofte uit de tabel vast; de
`/designsystem`-pagina toont de ramp als één plank en de vier
accentparen met hun gemeten contrast, in beide thema's.
