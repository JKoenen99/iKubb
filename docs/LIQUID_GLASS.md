# Liquid Glass op iOS

Apple's iOS 26-designtaal, toegepast op de iOS-build volgens de Human
Interface Guidelines (pagina's *Materials*, *Adopting Liquid Glass*,
*Toolbars*, *Buttons*, *Sheets*; gelezen op 2026-10-19). Flutter tekent
zijn eigen UI en heeft het systeemmateriaal niet, dus de regels zijn
nagebouwd in `lib/theme/glass.dart`; Android en web houden Material uit
dezelfde widgetboom.

## Wat de HIG voorschrijft en hoe het is toegepast

| HIG-regel | Bron | Implementatie |
|---|---|---|
| Liquid Glass vormt een aparte laag voor navigatie en bedieningselementen; nooit in de contentlaag | Materials | Glas alleen op: app bar-knoppen, de onderste actiebalk, sheets, zwevende icoonknoppen. Kaarten, standen, het veld en de regels blijven gewoon content. |
| Spaarzaam gebruiken, niet stapelen, max. ±3 groepen per toolbar | Adopting / Toolbars | Per scherm hooguit: één leading-schijf, één capsule met acties, één actiebalk. Nooit glas op glas. |
| *Regular* voor tekstrijke chrome; *clear* alleen boven rijke media, dan met een donkere dimlaag van 35 % | Materials | `GlassVariant.regular` (surface-tint 72 %) voor bars, toolbars, sheets. `GlassVariant.clear` (forestDeep 35 %) alleen voor de knoppen boven het houtnerf-thuisscherm en het donkere scorebord. |
| Content scrollt onder de bar door; scroll-edge-effect houdt de titel leesbaar | Adopting / Toolbars | `extendBodyBehindAppBar` op elk scherm; `KaatoAppBar` is transparant met een verloop van de achtergrondkleur als zachte scroll-edge. Lijsten beginnen onder de bar via de MediaQuery-inset en scrollen eronder door. |
| Groepeer verwante acties in één container; iconen, monochroom; één primaire actie getint, trailing | Toolbars / Buttons | `GlassGroup`: alle bar-acties in één capsule (iconen, monochroom). In `GlassToolbar` worden tonal-knoppen monochroom glas; alleen de bevestigknop blijft getint, rechts. |
| Capsule- en cirkelvormen, concentrisch met hun container | Adopting / Buttons | Theme op iOS: `StadiumBorder` voor Filled/Outlined/Text-knoppen, segmented controls en chips; glascontainers 26 pt superellips (`RoundedSuperellipseBorder`), sheets 34 pt. |
| Hit-regio minimaal 44×44 pt | Buttons | Ongewijzigd; `iOSTapTargetGuideline` getest op game, setup, settings. |
| Sheets: grotere hoekradius, half sheets los van de schermrand, grabber, content piept eromheen | Adopting / Sheets | `glassSheet`: 8 pt inzet, 34 pt hoeken, eigen grabber, glazen oppervlak; regels- en feedback-sheet. |
| Menu's nemen glas aan, met iconen | Adopting | `popupMenuTheme`: translucent, superellips 26 pt; de overflow-menu's hadden al iconen. |
| Reduce Transparency / Increase Contrast: minder of geen transparantie, zichtbare randen | Adopting / Materials | Flutter geeft geen Reduce Transparency door; *Increase Contrast* (`MediaQuery.highContrast`) is het dichtstbijzijnde signaal en schakelt blur uit: dekkende oppervlakken met een duidelijkere rand (getest). |
| Reduce Motion | Adopting | Geen glas-animaties toegevoegd; alle bestaande motion loopt al via `KaatoMotion.resolve`. |
| Kleur spaarzaam in chrome; monochrome labels boven kleurrijke content | Toolbars / Buttons | Bar-iconen zijn `onSurface`; boven houtnerf birch-wit op donker glas. |
| App-icoon in lagen (Icon Composer) | Adopting | Niet gedaan: vereist Xcode/Icon Composer op een Mac. Zie "Nog te doen". |

## Opbouw

- `lib/theme/glass.dart`
  - `LiquidGlass.isCupertino` (iOS/macOS-idioom) en `isEnabled`
    (idioom én geen Increase Contrast → echte blur).
  - `KaatoGlass`: `ClipRSuperellipse` + `BackdropFilter`(blur 18) +
    tint + specular rand (18 %) + sheen bovenaan + zachte schaduw.
  - `GlassGroup` (capsule met knoppen), `GlassToolbar` (zwevende
    actiebalk), `BottomActionBar` (toolbar op iOS, padding elders),
    `glassSheet` (inzet-sheet met grabber), `glassIconButton`.
- `lib/widgets/kaato_app_bar.dart`: de app bar voor alle schermen.
- `lib/theme/kaato_theme.dart`: vormen en bar/menu/sheet-thema's
  afhankelijk van `defaultTargetPlatform`.
- Tokens in `lib/theme/tokens.dart`: `KaatoRadius.glass/sheet/capsule`,
  `KaatoAlpha.glass*`, `KaatoMotion.glassBlur`.

## Native kant

Bouw met Xcode 26: systeemonderdelen die niet door Flutter worden
getekend (de deelsheet, toetsenbord, systeemdialogen, de Live Activity)
krijgen Liquid Glass vanzelf. `UIDesignRequiresCompatibility` staat
bewust niet in `Info.plist`.

## Prestaties

`BackdropFilter` is de duurste laag in Flutter. Per scherm staan er
hooguit drie (leading, acties, actiebalk); sheets voegen er één toe.
Profiel op een echt toestel vóór release; bij jank is `KaatoMotion.glassBlur`
verlagen de eerste knop.

## Nog te doen (niet vanuit deze omgeving)

- App-icoon in lagen maken met Icon Composer en in Xcode toevoegen.
- Visuele controle op een iPhone met iOS 26 en met Reduce Transparency
  aan; die instelling is in Flutter niet uitleesbaar, dus het dekkende
  fallbackpad is alleen via Increase Contrast getest.
- De `/designsystem`-pagina toont de glascomponenten met een
  "Preview iOS chrome"-schakelaar (zie `DESIGN_SYSTEM.md`); een echte
  blur-controle blijft toestelwerk.
