# iKubb testen op je eigen iPhone en iPad

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
   git checkout claude/kubb-scoreboard-spec-taaalb
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

- *"Untrusted Developer"*: stap 6, het certificaat vertrouwen.
- *"Developer Mode disabled"*: Ontwikkelaarsmodus aanzetten.
- *"No iPhone or iPad found"*: ontgrendelen, kabel controleren, of
  `flutter devices` draaien om te zien wat Flutter ziet.
- *`git pull failed`*: `git status` draaien en de uitvoer in de chat
  plakken. Lokale wijzigingen aan de ondertekening in Xcode worden door
  het script automatisch bewaard.
- *CocoaPods-fout*: `cd ios && pod repo update && cd ..`, dan opnieuw.
