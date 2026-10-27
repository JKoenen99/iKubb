# New game-redesign en kaartgebaseerd formulier-systeem

Implementatie van `iKubb_New_game_redesign.pdf` (drie pagina's: tablet
twee koloms met solo- en teamstand, en de telefoonvariant). Het ontwerp
vervangt het oude lijstformulier door een rustige kaarttaal die nu ook de
instellingen en de `/designsystem`-pagina draagt.

## Wat er veranderd is

### Het scherm (`lib/features/setup/setup_screen.dart`)

| Ontwerp | Implementatie |
|---|---|
| Twee kolommen op tablet, één kolom op telefoon | `LayoutBuilder`, omslagpunt 720 pt (`twoColumnWidth`); de brede variant staat gecentreerd op maximaal 960 pt (`KaatoLayout.maxWide`). |
| "Game": twee keuzekaarten (Number kubb / Kubb) met radio-stip | Vervallen in 0.4.0: de app speelt alleen nog nummerkubb. `ChoiceCard` blijft beschikbaar in het designsysteem. |
| Spelerskaarten: avatar, naam inline te hernoemen, teampil, verwijderen | `_PlayerRow` op een `FormCard`; de avatar is tegelijk de sleepgreep (`ReorderableDragStartListener`). Naam aantikken opent een inline `TextField`; `done` of buiten tikken bevestigt. |
| Namen optioneel, "+ Add player" voegt een genummerde speler toe | `addAutoPlayer` in de controller; genummerde spelers krijgen hun nummer op de avatar en worden niet in de recents bewaard. |
| Recente spelers als chips onder de lijst | `RecentChip`; gedimd zodra de speler al in de lijst staat. |
| Teams: schakelaar met uitleg, daarna twee getinte teamkaarten met naamveld en leden, plus "Swap teams" | `_TeamsSection`; walnoot voor A, fjord voor B (`teamColor`), nooit gelijk aan een spelerskleur. |
| House rules als steppers: target, back-to, elimination; Reset-knop | `StepperCard` (−/waarde/+, waarde aantikken opent een typ-dialoog). Target 10..200 in stappen van 5; back-to volgt mee onder het target; elimination 0 = Off. `Reset` is alleen actief als de regels afwijken van klassiek. |
| Samenvattingsbalk onderaan: aantal spelers, regel in één zin, "Start game" | `_SummaryBar` op `BottomActionBar` (glas op iOS). Een blokkade ("Add at least 2 players") vervangt de regelzin. |
| Telefoon: house rules en match-opties als rij met chevron die een sheet opent | `SettingCard` → `glassSheet`. |

### Gedeelde componenten (`lib/widgets/form_cards.dart`, nieuw)

`FormCard`, `FormLabel`, `SettingCard`, `SwitchCard`, `ChoiceCard`,
`StepperCard`, `DashedAddButton`, `AvatarCircle`, `TintPill`,
`RecentChip`. De instellingen (`settings_tiles.dart`) zijn op dezelfde
kaarten herbouwd, zodat Settings en New game één taal spreken.
`SectionHeader` kreeg een `detail` ("2 players") en een `trailing`-actie
("Shuffle order", "Reset").

### Model en state (`setup_controller.dart`, `player.dart`)

- `overshootResetValue` (standaard 25) en `missLimit` (0 = uit) vervangen
  de twee booleans; `overshootPolicy` en `eliminationEnabled` zijn afgeleid.
- `renamePlayer`, `swapTeams`, `setOvershootReset`, `setMissLimit`,
  `resetHouseRules`, `addAutoPlayer`.
- `Player.autoNumber` / `isAutoNamed` / `avatarLabel`.

### Design-systeempagina

Nieuwe sectie "Form cards (New game redesign)" met alle bovenstaande
componenten in hun standen, zodat een visuele review zonder flow kan.

## Toegankelijkheid en HIG

- Elk tikdoel minimaal 48 pt (`kMinInteractiveDimension`): naamveld,
  teampil, stepperwaarde, verwijderknop.
- De teampil heeft een actielabel ("Move Freya to Team B"); de teams-
  schakelaar en `SwitchCard` zijn met `MergeSemantics` één element.
- Titel en detail in `SectionHeader` wijken (ellipsis) vóór de actie, dus
  geen overflow bij grote tekst of smalle kolommen.
- Op iOS volgen de kaarten het Liquid Glass-thema (capsulevormige knoppen,
  glazen actiebalk en sheets); zie `LIQUID_GLASS.md`.

## Tests

`test/setup_flow_test.dart` is herschreven op de nieuwe flow (steppers,
optionele namen, teamkaarten, pil-verplaatsing en swap, recents). Alle
andere flows gebruiken de helpers `addPlayers`, `setTarget` en
`toggleTeams` uit `test/test_utils.dart`.

## Vertalingen

Nieuwe sleutels in alle tien talen: `gameSection`, `modeNumberDesc`,
`modeKubbDesc`, `modeNumberHint`, `playersCount`, `namesOptionalHint`,
`recentLabel`, `teamsOffDesc`, `teamsOnDesc`, `swapTeams`, `moveToTeam`,
`resetLabel`, `targetScoreDesc`, `backToLabel`, `backToDesc`,
`eliminationDesc`, `summaryFirstTo`, `summaryBackTo`, `summaryOutAfter`,
`summaryNoPenalty`, `summaryNoElimination`, `summaryInTeams`,
`editValueTitle`, `renamePlayer`. De niet-Engelse teksten zijn machinaal
vertaald en verdienen een korte native check.
