# Live Activity (Dynamic Island) — eenmalige Xcode-setup

De Flutter-kant is volledig geïmplementeerd: elke worp synchroniseert de
tussenstand naar een iOS Live Activity (`lib/features/game/live_score/`),
volledig no-op op Android/web en op iOS zonder de extensie. Wat rest is
het aanmaken van het widget-extensiontarget — dat kan alleen in Xcode op
een Mac (signing + target-registratie).

## Stappen (± 10 minuten)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. **File → New → Target… → Widget Extension.**
   - Product name: `LiveScoreWidget`
   - ✅ "Include Live Activity", ❌ "Include Configuration App Intent"
   - Embed in application: `Runner`.
3. Verwijder de gegenereerde template-Swift-bestanden in de nieuwe target
   en voeg het bestaande bestand toe:
   `ios/LiveScoreWidget/LiveScoreWidgetLiveActivity.swift`
   (File → Add Files…, target: LiveScoreWidget).
4. **App Groups** (beide targets — Runner én LiveScoreWidget):
   Signing & Capabilities → + Capability → App Groups →
   `group.nl.jasperkoenen.ikubb`.
5. Zet in de LiveScoreWidget-target de minimum deployment op **iOS 16.1**.
6. `NSSupportsLiveActivities` staat al in `ios/Runner/Info.plist` (klaar).
7. Build & run op een fysiek toestel met Dynamic Island (of iOS 16.1+
   voor de Lock-Screen-variant). Start een spel, doe een worp, ga naar
   het homescherm: de tussenstand verschijnt in het Dynamic Island;
   lang indrukken toont de uitgebreide weergave met beide namen en het
   doel ("→ 50").

## Gedrag

- Start bij de eerste worp; update bij elke worp/undo; verdwijnt bij
  winst of nieuw spel (en bij het geforceerd afsluiten van de app).
- Compact: beide scores (oak/birch). Expanded: namen + scores + doel.
- Merk-kleuren (birch/forest/oak) hardcoded in de widget — pas ze aan in
  `LiveScoreWidgetLiveActivity.swift` als de tokens ooit wijzigen.
