// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Numerokubbin tulostaulu';

  @override
  String get startScoring => 'Osaan säännöt — aloita pisteytys';

  @override
  String get teachMe => 'Opeta minulle peli';

  @override
  String get quickStart => 'Pikastartti';

  @override
  String get newGame => 'Uusi peli';

  @override
  String get rules => 'Säännöt';

  @override
  String get stats => 'Tilastot';

  @override
  String get confirmThrow => 'Vahvista heitto';

  @override
  String get miss => 'Ohi';

  @override
  String get undo => 'Kumoa';

  @override
  String needsExactly(int points) {
    return 'Tarvitsee tasan $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Yli meni — takaisin pisteisiin $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name voittaa!';
  }

  @override
  String get comingSoon => 'Tulossa pian';

  @override
  String get players => 'Pelaajat';

  @override
  String get addPlayer => 'Lisää pelaaja';

  @override
  String get playerName => 'Nimi';

  @override
  String get recentPlayers => 'Viimeisimmät pelaajat';

  @override
  String get teams => 'Joukkueet';

  @override
  String get teamA => 'Joukkue A';

  @override
  String get teamB => 'Joukkue B';

  @override
  String get autoBalance => 'Jaa automaattisesti';

  @override
  String get houseRules => 'Kotisäännöt';

  @override
  String get targetScore => 'Tavoitepisteet';

  @override
  String get overshootRule => 'Ylitys';

  @override
  String get policyReset => 'Palautus';

  @override
  String get policyHalf => 'Puolet tavoitteesta';

  @override
  String get policyNone => 'Ei rangaistusta';

  @override
  String get eliminationRule => 'Putoaminen';

  @override
  String get missLimit => 'Ohiheitot putoamiseen';

  @override
  String get shuffleOrder => 'Sekoita järjestys';

  @override
  String get startGame => 'Aloita peli';

  @override
  String get needTwoPlayers => 'Lisää vähintään 2 pelaajaa';

  @override
  String get needBothTeams => 'Molemmissa joukkueissa on oltava pelaaja';

  @override
  String get custom => 'Mukautettu';

  @override
  String get rulesSearchHint => 'Etsi säännöistä';

  @override
  String get rulesNoResults => 'Hakua vastaavia sääntöjä ei löytynyt';

  @override
  String get activeRulesLabel => 'Tämä peli';

  @override
  String get catSetup => 'Aloitus & kenttä';

  @override
  String get catThrowing => 'Heittäminen';

  @override
  String get catScoring => 'Pisteet';

  @override
  String get catOvershoot => 'Ylitys & palautus';

  @override
  String get catMisses => 'Ohiheitot & putoaminen';

  @override
  String get catWinning => 'Voittaminen';

  @override
  String get catTeams => 'Joukkueet';

  @override
  String get ruleFormationTitle => 'Aloitusmuodostelma';

  @override
  String get ruleFormationBody =>
      '12 numeroitua keilaa aloittavat tiiviissä vinoneliössä 3–4 metrin päässä heittoviivasta.';

  @override
  String get rulePinsStandTitle => 'Keilat jäävät kaatumispaikalleen';

  @override
  String get rulePinsStandBody =>
      'Jokaisen heiton jälkeen kaatuneet keilat nostetaan pystyyn siihen, mihin ne kaatuivat — kenttä leviää pelin edetessä.';

  @override
  String get ruleTurnsTitle => 'Heittäkää vuorotellen';

  @override
  String get ruleTurnsBody =>
      'Kukin puoli heittää yhden kapulan vuorollaan, aina samassa järjestyksessä.';

  @override
  String get ruleUnderhandTitle => 'Heitä alakautta';

  @override
  String get ruleUnderhandBody => 'Kapula heitetään aina alakautta.';

  @override
  String get ruleOnePinTitle => 'Yksi keila kaatuu';

  @override
  String get ruleOnePinBody =>
      'Kaada tasan yksi keila, niin saat sen numeron verran pisteitä.';

  @override
  String get ruleManyPinsTitle => 'Monta keilaa kaatuu';

  @override
  String get ruleManyPinsBody =>
      'Kaada useita keiloja, niin saat pisteiksi keilojen määrän, et niiden summaa.';

  @override
  String get ruleManyPinsDetail =>
      'Esimerkki: keilojen 7, 9 ja 12 kaataminen tuo 3 pistettä.';

  @override
  String get ruleLeaningTitle => 'Nojaavat keilat eivät laske';

  @override
  String get ruleLeaningBody =>
      'Toisen keilan tai kapulan varaan jäänyt keila ei ole kaatunut.';

  @override
  String get ruleOvershootTitle => 'Älä ylitä tavoitetta';

  @override
  String get ruleOvershootBody =>
      'Jos pisteesi ylittäisivät tavoitteen, putoat takaisin (klassisesti yli 50 pudottaa sinut 25:een).';

  @override
  String get ruleOvershootDetail =>
      'Kotisäännöt voivat muuttaa tätä: paluu puoleen tavoitteesta tai ei rangaistusta lainkaan.';

  @override
  String get ruleMissesTitle => 'Kolme ohiheittoa ja putoat';

  @override
  String get ruleMissesBody =>
      'Jos et saa pisteitä kolmella peräkkäisellä vuorolla, putoat pelistä (kun putoaminen on käytössä).';

  @override
  String get ruleMissesDetail =>
      'Pelaajakorttisi pisteet näyttävät ohiheittoputkesi.';

  @override
  String get ruleExactTitle => 'Osu tavoitteeseen tasan';

  @override
  String get ruleExactBody =>
      'Ensimmäinen puoli, joka saavuttaa tavoitepisteet tasan, voittaa pelin.';

  @override
  String get ruleLastStandingTitle => 'Viimeinen jäljellä';

  @override
  String get ruleLastStandingBody =>
      'Jos kaikki muut puolet putoavat, jäljellä oleva puoli voittaa.';

  @override
  String get ruleTeamsTitle => 'Yksin tai joukkueissa';

  @override
  String get ruleTeamsBody =>
      'Pelatkaa yksi vastaan yksi tai kahdessa joukkueessa — joukkue heittää yhtenä puolena ja jäsenet vuorottelevat.';

  @override
  String get rematch => 'Uusintaottelu';

  @override
  String get skip => 'Ohita';

  @override
  String get next => 'Seuraava';

  @override
  String get tourTryIt => 'Kokeile — napauta kaatuneita keiloja';

  @override
  String get historyTitle => 'Historia';

  @override
  String get noGamesYet => 'Ei vielä pelejä — kenttä odottaa!';

  @override
  String get gamesPlayed => 'Pelit';

  @override
  String get wins => 'Voitot';

  @override
  String get winRate => 'Voittoprosentti';

  @override
  String get avgPerThrow => 'Pisteet/heitto keskimäärin';

  @override
  String get mostHitPin => 'Suosikkikeila';

  @override
  String get statMisses => 'Ohiheitot';

  @override
  String get statOvershoots => 'Ylitykset';

  @override
  String get statEliminations => 'Putoamiset';

  @override
  String get numberPad => 'Numeronäppäimet';

  @override
  String get tapPins => 'Napauta keiloja';

  @override
  String get scoreboardMode => 'Tulostaulu';

  @override
  String get share => 'Jaa';

  @override
  String get settings => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get systemDefault => 'Järjestelmän oletus';

  @override
  String get haptics => 'Värinäpalaute';

  @override
  String get keepAwake => 'Pidä näyttö päällä';

  @override
  String get homeLabel => 'Koti';

  @override
  String pinSemantics(int number) {
    return 'Keila $number';
  }

  @override
  String get cancel => 'Peruuta';

  @override
  String get newGameConfirmTitle => 'Aloitetaanko uusi peli?';

  @override
  String get newGameConfirmBody => 'Nykyinen peli hylätään.';
}
