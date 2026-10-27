# Kaato testen op je eigen iPhone en iPad

> Sinds 0.4.0 heet de app Kaato met bundel-ID `nl.jasperkoenen.kaato`.
> De eerste `tool/ios.sh` daarna maakt het nieuwe profiel zelf aan en
> zet Kaato als nieuwe app op je toestel. Verwijder de oude iKubb-app; met
> een gratis Apple ID mag je maar drie eigen apps tegelijk hebben. De
> repo en de map heten nog `iKubb` tot je de GitHub-repo hernoemt.

Route zonder betaald developeraccount: bouwen op je Mac met Xcode en een
gratis Apple ID. Eén keer instellen, daarna bijwerken met één commando.

## Eenmalig

1. **Xcode** uit de App Store, één keer openen, Apple ID toevoegen via
   Xcode, Settings, Accounts. Daarna in Terminal:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   sudo xcodebuild -license accept
   ```
2. **Homebrew-pakketten**: `brew install gh cocoapods`, daarna
   `gh auth login` (GitHub.com, HTTPS, inloggen via de browser).
3. **Flutter 3.47.7**, dezelfde versie als CI:
   ```bash
   git clone https://github.com/flutter/flutter.git -b 3.47.7 ~/development/flutter
   echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   flutter doctor
   ```
   "Unknown channel" in `flutter doctor` is verwacht (vaste versie) en
   onschadelijk. Niet `flutter upgrade` draaien.
4. **Repo ophalen**:
   ```bash
   cd ~/projects
   gh repo clone JKoenen99/iKubb
   cd iKubb
   git switch main
   ```
5. **Ondertekening**: `open ios/Runner.xcworkspace`, target Runner,
   Signing & Capabilities: "Automatically manage signing" aan, Team
   "(Personal Team)". De melding "Your team has no devices" verdwijnt na
   stap 6 met "Try Again". De suggestie "Update to recommended settings"
   altijd met Cancel wegklikken.
6. **Per toestel**: met kabel aansluiten, "Vertrouw", in Xcode kiezen als
   bestemming, op het toestel Ontwikkelaarsmodus aanzetten (Instellingen,
   Privacy en beveiliging). Na de eerste installatie: Instellingen,
   Algemeen, VPN en apparaatbeheer, je Apple Development-certificaat
   vertrouwen.
7. **Optioneel, kabelloos**: in Xcode, Window, Devices and Simulators,
   "Connect via network" aanvinken per toestel.

## Bijwerken naar de nieuwste versie

```bash
cd ~/projects/iKubb
tool/ios.sh
```

Het script haalt de nieuwste code op, toont wat er nieuw is, bouwt één
keer en installeert op elk aangesloten iPhone en iPad. Je gegevens in de
app blijven bewaard.

| Commando | Wat het doet |
|---|---|
| `tool/ios.sh` | ophalen, bouwen, installeren op alle toestellen |
| `tool/ios.sh --branch main` | eerst naar `main` wisselen (de stabiele versie) |
| `tool/ios.sh --branch feature/x` | een branch uitproberen die Claude noemt |
| `tool/ios.sh --device ipad` | alleen het toestel waarvan de naam "ipad" bevat |
| `tool/ios.sh --no-pull` | bouwen wat er nu lokaal staat |
| `tool/ios.sh --dev` | debug-run met hot reload (r, R, q) op één toestel |

Met een gratis Apple ID opent de app na 7 dagen niet meer; draai dan
`tool/ios.sh` opnieuw.

## Welke versie staat er op mijn toestel?

Onderaan Settings staat bijvoorbeeld:

```
Version 0.2.0 (2), commit 58cf66b
```

- `0.2.0` is de versie, `(2)` het buildnummer, beide uit `pubspec.yaml`
  (`version: 0.2.0+2`).
- `58cf66b` is de commit waaruit gebouwd is; vergelijk met `git log
  --oneline` of GitHub. Een `+` erachter betekent: gebouwd met lokale
  wijzigingen die nog niet gepusht zijn.
- De web-preview toont dezelfde regel met de commit van die build.
- Lang drukken selecteert de tekst, handig voor een bugmelding.

## Versieregels

`version: MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`:

- **BUILD** (+2, +3, …): verhogen bij elke build die je op toestellen of
  aan testers geeft. Altijd ophogen, nooit hergebruiken; TestFlight en de
  App Store eisen dat later ook.
- **PATCH** (0.2.1): alleen fixes.
- **MINOR** (0.3.0): nieuwe functies of een merkbare ontwerpwijziging.
- **MAJOR** (1.0.0): de eerste publieke release.

Bij elke versie hoort een regel in `CHANGELOG.md`.

## Problemen

- *"Untrusted Developer"*: stap 6, het certificaat vertrouwen. Dat
  hoort eenmalig per toestel te zijn: iOS trekt het vertrouwen alleen in
  als de laatste app van jouw certificaat van het toestel verdwijnt.
  `tool/ios.sh` installeert daarom over de bestaande app heen (zoals
  Xcode) en nooit via `flutter install`, dat eerst de-installeert. Moet
  je toch opnieuw vertrouwen, dan heeft Xcode een nieuw certificaat
  gemaakt (bijvoorbeeld na een nieuwe Mac of een ingetrokken
  certificaat).
- *"Developer Mode disabled"*: Ontwikkelaarsmodus aanzetten.
- *"No iPhone or iPad found"*: ontgrendelen, kabel controleren, of
  `flutter devices` draaien om te zien wat Flutter ziet.
- *`git pull failed`*: `git status` draaien en de uitvoer in de chat
  plakken.
- *"Your local changes clashed with the update"*: je had lokale
  wijzigingen (meestal door Xcode) in een bestand dat de update ook
  aanpast. Het script stopt dan vóór het bouwen en noemt het commando
  om de gepushte versie terug te zetten; jouw wijzigingen blijven in
  `git stash list`. Het ondertekeningsteam staat sinds 0.4.0 in de repo,
  dus Xcode hoeft daar lokaal niets meer aan te veranderen.
- *CocoaPods-fout*: `cd ios && pod repo update && cd ..`, dan opnieuw.

## Branches

`main` is de versie die altijd werkt. Nieuw werk staat eerst op een eigen
branch (`feature/…`, `design/…`, `fix/…`); Claude noemt bij elke
wijziging op welke branch het staat en met welk commando je het
uitprobeert. Na jouw akkoord gaat het naar `main`. De regels staan in
`CLAUDE.md`.

Het script bouwt wat er op je Mac is uitgecheckt; de regel `Branch:`
bovenaan de uitvoer en de commit onderaan Settings vertellen welke versie
je hebt.
