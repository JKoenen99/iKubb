# Changelog

Versies volgen `MAJOR.MINOR.PATCH+BUILD` uit `pubspec.yaml`; zie
`docs/IOS_DEVICE_TESTING.md` voor de regels. De app toont de versie en
commit onderaan Settings.

## 0.5.0 (5)

- **Nieuwe illustratie op Home**: Kaato aan de werkbank, kegels aan het
  snijden, vervangt de getekende Viking boven het woordmerk. Op kleine
  schermen krimpt hij mee, zodat de knoppen altijd passen. De Viking
  blijft bij de rondleiding, de winst en lege schermen.
- **Nieuwe SVG's uit Illustrator**: zet ze in `assets/character/` en draai
  `dart tool/inline_svg_styles.dart assets/character/<bestand>.svg`.
  Flutter negeert het `<style>`-blok dat Illustrator schrijft en tekent
  anders alles zwart; een test bewaakt dit.

## 0.4.0 (4)

De app heet nu **Kaato** (Fins voor het vellen, de omgegooide kegel) en
speelt alleen nog nummerkubb.

- **Nieuwe naam overal**: app-naam op iOS, Android en web, woordmerk,
  tagline in tien talen, deelkaart, Live Activity, code en documentatie.
- **Nieuwe bundel-ID**: `nl.jasperkoenen.kaato` (was `…ikubb`). Op je
  toestel verschijnt Kaato als nieuwe app; de oude iKubb-app kun je
  verwijderen. Spelers en geschiedenis gaan niet mee.
- **Klassiek kubb verwijderd**: spel, regels, rondleiding, scorebord,
  statistieken en de engine-onderdelen. De rondleiding begint direct met
  de regels, New game heeft geen spelkeuze meer, de samenvatting zegt
  "First to 50" in plaats van "Number kubb, first to 50".
- Bewaarde klassieke-kubbwedstrijden uit eerdere builds worden bij het
  laden overgeslagen; nummerkubb-geschiedenis blijft staan.
- 71 ongebruikte teksten uit alle tien talen verwijderd.

## 0.3.0 (3)

- **Segmentknop opnieuw ontworpen**: geen capsule met randen meer, maar
  een verzonken track met een verhoogde tegel die naar de keuze schuift
  (iOS-anatomie). Geldt overal: thema, spelmodus, wedstrijd, beurtklok,
  regels en invoermodus in het spel. Pijltjestoetsen werken.
- **Bijwerken op toestellen**: `tool/ios.sh` installeert over de
  bestaande app heen. Je hoeft de ontwikkelaar niet steeds opnieuw te
  vertrouwen en de gegevens in de app blijven bewaard.

## 0.2.0 (2)

Eerste build met versienummer in de app.

- **Testen op iPhone en iPad**: `tool/ios.sh` werkt alle aangesloten
  toestellen bij met één commando; versie en commit staan onderaan
  Settings en in de web-preview.
- **Dark mode**: gevulde knoppen, het gekozen segment en de actieve
  standenkaart hebben weer lichte labels (nachtgroene vullingen).
- **Inputs**: één recept voor elk invoerelement; de taalkeuze is een
  echt invoerveld met rand.
- **Houtpalet**: vier houttinten met vaste rollen, elk op AA-contrast.
- **New game**: kaartgebaseerd ontwerp, twee kolommen op iPad,
  optionele namen, teamkaarten, steppers voor de huisregels.
- **Liquid Glass** op iOS volgens de Apple HIG.
- **Feedback**: sterren, tags en een korte tekst aan het eind van een
  spel, in Settings en na de rondleiding, opgeslagen in Supabase.
- **Designsystem-pagina** als Storybook: elk token en component met
  props, varianten en toegankelijkheid.
- Review: dependency-updates, security-hardening, QA-fixes en een
  copywriting-ronde in alle tien talen.

## 0.1.0 (1)

*Toen nog iKubb.*

Eerste werkende versie: number kubb (Mölkky-stijl) en klassiek kubb,
rondleiding, regels met illustraties, geschiedenis en statistieken,
deelkaarten, scorebord-modus voor iPad, tien talen, licht en donker
thema. Deze builds tonen nog geen versienummer in de app.
