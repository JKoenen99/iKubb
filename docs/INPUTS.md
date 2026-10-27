# Inputs: één recept voor elk bedieningselement

Aanleiding: de segmentknop in Settings toonde een houtvulling met een witte
Material-outline, en de taal-dropdown had alleen een onderstreping. Elk
invoerelement volgt nu hetzelfde recept, naar het voorbeeld van Airbnb
(DLS), Shopify Polaris en de Apple HIG: een zichtbare rand in rust, een
sterkere primaire rand bij focus, één duidelijke "geselecteerd"-vulling.

## Het recept (`lib/theme/ikubb_theme.dart`)

| Staat | Vulling | Rand | Bron |
|---|---|---|---|
| Rust | `surface` (één stap lichter dan de kaart) | `outline` 1,5 pt | `IKubbPalette.lineLight` / `lineDark` |
| Focus | idem | `primary` 2 pt | forest (licht) / geschuurd eiken (donker) |
| Fout | idem | `error` 1,5 pt, 2 pt bij focus | berry (licht) / berryLight (donker) |
| Uitgeschakeld | idem | `outlineVariant` 1,5 pt | `lineSoftLight` / `lineSoftDark` |

Hoekradius 12 pt (`IKubbRadius.md`), contentpadding 16 × 12. De
lijnkleuren halen 3:1 op de kaart waar ze op staan (WCAG 1.4.11), vastgelegd
in `test/palette_test.dart`.

## Wat het recept raakt

- **TextField**: globaal via `inputDecorationTheme`; lokale
  `OutlineInputBorder`-overrides zijn verwijderd (regels-zoekveld,
  feedbackcommentaar). De inline naamvelden in New game (spelernaam,
  teamnaam) tonen nu ook de rand zodra ze actief zijn.
- **SelectField** (`lib/widgets/form_cards.dart`): vervangt `DropdownButton`.
  Hetzelfde veld met de huidige waarde en een chevron; opent een menu zo
  breed als het veld, met een vinkje op de huidige optie. Semantiek: knop
  met label en waarde.
- **Segmentknop** (`SegmentedControl`, via `AdaptiveChoice`): geen
  Material-`SegmentedButton` meer maar de track-en-tegel-anatomie van iOS:
  een verzonken track (tekstkleur op 8 % licht, 10 % donker), een
  verhoogde tegel met zachte schaduw die naar het gekozen segment schuift,
  gelijke segmentbreedtes, geen randen en geen merkkleurvulling. Hoeken
  concentrisch: track 12, inzet 4, tegel 8 (geen capsule). Het actieve
  label is volle kleur en semibold, de andere 70 % en medium. Pijltjestoetsen
  verplaatsen de keuze. Bij grote tekst vallen de segmenten terug op chips.
- **Chips**: lijn in rust, `primaryContainer`-vulling en licht label bij
  selectie (feedback-tags, regelchips, de chip-variant van AdaptiveChoice).
- **Dark theme**: `error` is nu `berryLight` (AA op donkere kaarten) en
  `outline`/`outlineVariant` zijn gezet, zodat Material-componenten die
  die tokens lezen (dividers, tabelranden) dezelfde lijn gebruiken.
- **SwitchCard** accepteert `onChanged: null` voor een uitgeschakelde rij.

Alle staten staan onder "Inputs" op de `/designsystem`-pagina.
