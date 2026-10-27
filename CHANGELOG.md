# Changelog

Versies volgen `MAJOR.MINOR.PATCH+BUILD` uit `pubspec.yaml`; de regels
staan in `AGENTS.md`. De app toont de versie en
commit onderaan Settings.

## 0.6.0 (8)

- **Nieuwe hoofdafbeelding op Home**: Kaato die de werpstok gooit, zonder
  witte achtergrond, in plaats van Kaato aan de werkbank. Hij vult alle
  ruimte boven de naam en de knoppen, met de gewone marge aan de zijkant;
  op de iPad wordt hij breder dan de knoppen.
- De werkbank-illustratie is uit de app gehaald (hij staat nog in de
  geschiedenis van de repository).

## 0.5.0 (7)

- **Nieuwe illustratie op Home**: Kaato aan de werkbank, kegels aan het
  snijden, vervangt de getekende Viking boven het woordmerk. Op kleine
  schermen krimpt hij mee, zodat de knoppen altijd passen. De Viking
  blijft bij de rondleiding, de winst en lege schermen.
- **Nieuwe SVG's uit Illustrator**: zet ze in `assets/character/` en draai
  `dart tool/inline_svg_styles.dart assets/character/<bestand>.svg`.
  Flutter negeert het `<style>`-blok dat Illustrator schrijft en tekent
  anders alles zwart; een test bewaakt dit.

## 0.4.2 (6)

- **Instellingenknop op Home leesbaar in licht thema** (iOS): het
  tandwiel stond donker op de donkere glazen schijf. Knoppen op helder
  glas houden nu in beide thema's een lichte glyph.

## 0.4.1 (5)

- **Werkafspraken op één plek**: `AGENTS.md` beschrijft hoe iedereen aan
  Kaato werkt, mens of agent: wanneer een nieuwe branch, checks vóór een
  push, versies, het designsysteem, teksten en documentatie. Claude,
  Copilot en Gemini lezen het automatisch via hun eigen bestand.
- **Documentatie bijgewerkt**: `docs/README.md` zegt welke documenten
  actueel zijn en welke gedateerde rapporten; de spec beschrijft wat er
  gebouwd is en markeert wat nog gepland staat; geen verwijzingen meer
  naar klassiek kubb of oude componenten in de actuele documenten.
- **Designsystem-pagina**: voorbeelden en "gebruikt in"-notities zonder
  klassiek kubb.
- **Supabase**: de tabelomschrijving van de feedbacktabel zegt nu Kaato
  (alleen metadata; de feedback zelf is ongewijzigd).

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
