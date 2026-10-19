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
  String get tagline => 'Kubbin tulostaulu';

  @override
  String get startScoring => 'Osaan säännöt, aloita pisteytys';

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
  String policyReset(int score) {
    return 'Takaisin $score:een';
  }

  @override
  String get policyHalf => 'Puolet tavoitteesta';

  @override
  String get policyNone => 'Ei rangaistusta';

  @override
  String get eliminationRule => 'Putoaminen';

  @override
  String get missLimit => 'Ohiheitot ennen putoamista';

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
  String get activeRulesLabel => 'Voimassa olevat kotisäännöt';

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
      'Pelaajat heittävät vuorotellen kiinteässä järjestyksessä — yksi keppi per heitto.';

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
      'Keila, joka nojaa toiseen keilaan tai keppiin, ei laske kaatuneeksi.';

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
      'Pistekortin pallot laskevat peräkkäiset hudit.';

  @override
  String get ruleExactTitle => 'Osu tavoitteeseen tasan';

  @override
  String get ruleExactBody =>
      'Peli päättyy, kun pelaaja tai joukkue saavuttaa tavoitepisteet tasan ensimmäisenä.';

  @override
  String get ruleLastStandingTitle => 'Viimeinen jäljellä';

  @override
  String get ruleLastStandingBody =>
      'Jos kaikki muut on pudotettu, viimeisenä jäljellä oleva pelaaja tai joukkue voittaa.';

  @override
  String get ruleTeamsTitle => 'Yksin tai joukkueissa';

  @override
  String get ruleTeamsBody =>
      'Pelaa yksi vastaan yksi tai kahdessa joukkueessa — joukkue jakaa yhden vuoron ja jäsenet heittävät vuorotellen.';

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
  String get avgPerThrow => 'Pisteitä per heitto';

  @override
  String get mostHitPin => 'Osutuin keila';

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
  String get systemDefault => 'Järjestelmä';

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
  String get newGameConfirmBody => 'Menetät käynnissä olevan pelin.';

  @override
  String get theme => 'Teema';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get delete => 'Poista';

  @override
  String get clearHistory => 'Tyhjennä historia';

  @override
  String get clearHistoryConfirmBody =>
      'Tämä tyhjentää kaikki pelit ja tilastot.';

  @override
  String get modeNumber => 'Numerokubb';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Ottelu';

  @override
  String get bestOfSingle => 'Yksi peli';

  @override
  String get bestOfThree => 'Paras kolmesta';

  @override
  String get turnClockLabel => 'Heittokello';

  @override
  String get offLabel => 'Pois';

  @override
  String get kingLabel => 'Kuningas';

  @override
  String get kingWarningTitle => 'Kaadetaanko kuningas?';

  @override
  String get kingWarningBody =>
      'Kaikki ei ole vielä nurin — kuninkaan osuminen nyt häviää pelin.';

  @override
  String get advantageLine => 'Etulinja';

  @override
  String get throwInTitle => 'Heitä kaatuneet kubbit hyökkääjien puoliskolle.';

  @override
  String get outTwice => 'Rangaistuskubbit (kahdesti ulos)';

  @override
  String get done => 'Valmis';

  @override
  String get nextGameLabel => 'Seuraava peli';

  @override
  String earlyKingBanner(String name) {
    return '$name kaatoi kuninkaan liian aikaisin!';
  }

  @override
  String get catKubbSetup => 'Aloitus ja joukkueet';

  @override
  String get catKubbBatons => 'Heittokapulat';

  @override
  String get catKubbFieldKubbs => 'Kenttäkubbit';

  @override
  String get catKubbKing => 'Kuningas';

  @override
  String get ruleKubbFieldTitle => 'Kenttä';

  @override
  String get ruleKubbFieldBody =>
      'Kaksi joukkuetta seisoo vastakkain kentällä. Kumpikin asettaa viisi kubbia takarajalleen, ja kuningas seisoo yksin keskellä.';

  @override
  String get ruleKubbFieldDetail =>
      'Turnauskentät ovat 5 × 8 metriä. Puistossa riittävät kaksi takkia ja hyvä arvio — pidä puoliskot suunnilleen yhtä suurina.';

  @override
  String get ruleKubbTeamsTitle => 'Yhdestä kuuteen per joukkue';

  @override
  String get ruleKubbTeamsBody =>
      'Kubb on joukkuepeli: yhdestä kuuteen pelaajaa per joukkue. Joukkuetoverit jakavat kuusi kapulaa ja heittävät vuorotellen.';

  @override
  String get ruleKubbBatonsTitle => 'Kuusi kapulaa vuorossa';

  @override
  String get ruleKubbBatonsBody =>
      'Hyökkäävä joukkue heittää kuusi kapulaa vastustajan kubbeja kohti — alakautta, pystysuunnassa pyörien.';

  @override
  String get ruleKubbBatonsDetail =>
      'Ei helikopteriheittoja: kapulan on pyörittävä pystysuunnassa, ei koskaan sivuttain. Kaatuneet kubbit jäävät maahan vuoron loppuun asti.';

  @override
  String get ruleKubbThrowInTitle => 'Kaatuneet kubbit palaavat';

  @override
  String get ruleKubbThrowInBody =>
      'Kapuloiden jälkeen puolustajat heittävät jokaisen kaatuneen kubbin hyökkääjien puoliskolle. Sinne minne kubbi laskeutuu, se nostetaan kenttäkubbiksi.';

  @override
  String get ruleKubbThrowInDetail =>
      'Puolustajat valitsevat mihin tähtäävät — lähekkäin seisovat kubbit on paljon helpompi kaataa yhdellä kapulalla.';

  @override
  String get ruleKubbFieldFirstTitle => 'Kenttäkubbit ensin';

  @override
  String get ruleKubbFieldFirstBody =>
      'Hyökkääjien on kaadettava kaikki pystyssä olevat kenttäkubbit ennen kuin takarajan kubbiin saa osua. Liian aikaisin kaadettu takarajan kubbi nostetaan takaisin.';

  @override
  String get ruleKubbPenaltyTitle => 'Kahdesti ulos = rangaistus';

  @override
  String get ruleKubbPenaltyBody =>
      'Kubb, joka heitetään kahdesti kentän ulkopuolelle, muuttuu rangaistuskubbiksi: toinen joukkue asettaa sen minne tahansa puoliskolleen — vaikka aivan kuninkaan viereen.';

  @override
  String get ruleKubbAdvantageTitle => 'Etulinja';

  @override
  String get ruleKubbAdvantageBody =>
      'Jos vastustajat jättävät kenttäkubbeja pystyyn puoliskollesi, joukkueesi saa heittää kapulat lähimpänä kuningasta seisovan kubbin tasalta.';

  @override
  String get ruleKubbKingTitle => 'Kuningas ratkaisee';

  @override
  String get ruleKubbKingBody =>
      'Vasta kun jokainen kubb puolustavalla puoliskolla on kaatunut, saat tähdätä kuninkaaseen. Kaada se, ja peli on teidän.';

  @override
  String get ruleKubbEarlyKingTitle => 'Ei ennen kuin rivi on kaatunut';

  @override
  String get ruleKubbEarlyKingBody =>
      'Jos kaadat kuninkaan ennen kuin kaikki muu on kaatunut — vaikka vahingossa — joukkueesi häviää pelin siihen paikkaan.';

  @override
  String get ruleKubbMatchTitle => 'Paras kolmesta';

  @override
  String get ruleKubbMatchBody =>
      'Turnauksissa ottelu pelataan paras kolmesta -muodossa. Joukkueet vuorottelevat siitä, kumpi aloittaa kunkin pelin.';

  @override
  String get ruleKubbMatchDetail =>
      'Heittokellon ollessa päällä joukkueella on kiinteä aika kuuden kapulan heittoon. Kello on ohjeellinen — sovellus ei koskaan estä heittoa.';

  @override
  String get tourModePickTitle => 'Mitä peliä pelaatte?';

  @override
  String get tourModePickBody =>
      'Molemmat löytyvät tästä sovelluksesta. Valitse toinen opeteltavaksi — voit vaihtaa milloin vain.';

  @override
  String get tourModeNumberDesc =>
      'Kaksitoista numeroitua keilaa. Kilpajuoksu tasan 50:een.';

  @override
  String get tourModeKubbDesc =>
      'Kaksi joukkuetta, viisi kubbia kummallakin — ja kuningas.';

  @override
  String get statKingsFelled => 'Kaadetut kuninkaat';

  @override
  String get statKubbsPerBaton => 'Kubbeja per kapula';

  @override
  String get statAdvantageTurns => 'Etulinjavuorot';

  @override
  String get statEarlyKings => 'Liian aikaiset kuninkaat';

  @override
  String get filterAll => 'Kaikki';

  @override
  String get closeLabel => 'Sulje';

  @override
  String get increaseLabel => 'Lisää';

  @override
  String get decreaseLabel => 'Vähennä';

  @override
  String kubbStandingSemantics(int number) {
    return 'Kubb $number, pystyssä';
  }

  @override
  String kubbSelectedSemantics(int number) {
    return 'Kubb $number, merkitty kaatuneeksi';
  }

  @override
  String get kingSafeSemantics => 'Kuningas — kaada se ja voita';

  @override
  String get kingRiskySemantics =>
      'Kuningas — siihen osuminen nyt häviää pelin';

  @override
  String batonsLeftSemantics(int remaining, int total) {
    return '$remaining/$total kapulaa jäljellä';
  }

  @override
  String missesSemantics(int count, int limit) {
    return '$count/$limit hutia';
  }

  @override
  String get statsErrorBody => 'Tilastojasi ei voitu ladata.';

  @override
  String get retryLabel => 'Yritä uudelleen';

  @override
  String get deleteGameLabel => 'Poista peli';

  @override
  String get newMatchConfirmTitle => 'Aloitetaanko uusi ottelu?';

  @override
  String get newMatchConfirmBody => 'Menetät käynnissä olevan ottelun.';

  @override
  String get settingsAppearance => 'Ulkoasu';

  @override
  String get settingsDuringPlay => 'Pelin aikana';

  @override
  String get settingsLearn => 'Opi';

  @override
  String get settingsAbout => 'Tietoja';

  @override
  String get designSystemLabel => 'Design system';

  @override
  String get licensesLabel => 'Avoimen lähdekoodin lisenssit';

  @override
  String confirmThrowCount(int count) {
    return 'Vahvista heitto (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Jatka peliä · $summary';
  }

  @override
  String matchScore(int a, int b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody => 'Tämä peli poistetaan historiastasi.';

  @override
  String get newMatch => 'Uusi ottelu';

  @override
  String playerN(int n) {
    return 'Pelaaja $n';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String removePlayer(String name) {
    return 'Poista $name';
  }

  @override
  String get showDetails => 'Lisätietoja';

  @override
  String get toppleKing => 'Kaada kuningas';

  @override
  String turnClockSemantics(int seconds) {
    return 'Heittokellossa $seconds sekuntia jäljellä';
  }

  @override
  String baselineStandingSemantics(int count) {
    return '$count takalinjan kubbia pystyssä';
  }

  @override
  String get opensRuleHint => 'Avaa säännön';

  @override
  String get clearSearch => 'Tyhjennä haku';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name heittää $points, nyt $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name heittää ohi';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name ylittää ja putoaa $total:een';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name putoaa pelistä';
  }

  @override
  String get feedbackPromptGameTitle => 'Miten pisteenlasku sujui iKubbilla?';

  @override
  String get feedbackPromptTourTitle => 'Selittikö kierros pelin?';

  @override
  String get feedbackSheetTitle => 'Palautteesi';

  @override
  String get feedbackNotNow => 'Ei nyt';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count/5 tähteä';
  }

  @override
  String get feedbackWhatLiked => 'Mikä toimi hyvin?';

  @override
  String get feedbackWhatImprove => 'Mikä voisi olla paremmin?';

  @override
  String get feedbackCommentHint => 'Jotain muuta? (valinnainen)';

  @override
  String get feedbackSubmit => 'Lähetä palaute';

  @override
  String get feedbackThanks => 'Kiitos, tämä auttaa meitä parantamaan!';

  @override
  String get feedbackSection => 'Palaute';

  @override
  String get feedbackGive => 'Anna palautetta';

  @override
  String get feedbackGiveSubtitle => 'Kerro kehittäjälle, mitä parantaa';

  @override
  String get feedbackPrivacyNote =>
      'Anonyymi: tallennamme vain arvion, tunnisteet, kommentin ja sovellusversion.';

  @override
  String get tagEasyScoring => 'Helppo pisteenlasku';

  @override
  String get tagRulesHelpful => 'Säännöt auttoivat';

  @override
  String get tagLooksGreat => 'Näyttää hyvältä';

  @override
  String get tagFast => 'Nopea';

  @override
  String get tagStatsFun => 'Tilastot ovat hauskoja';

  @override
  String get tagShareCard => 'Jakokortti';

  @override
  String get tagConfusing => 'Sekava';

  @override
  String get tagMissingFeature => 'Ominaisuus puuttuu';

  @override
  String get tagBug => 'Jokin meni rikki';

  @override
  String get tagTooManyTaps => 'Liikaa napautuksia';

  @override
  String get tagRulesUnclear => 'Säännöt epäselvät';

  @override
  String get tagTranslation => 'Käännösvirhe';

  @override
  String get tagOther => 'Muu';

  @override
  String get gameSection => 'Peli';

  @override
  String get modeNumberDesc =>
      'Pisteitä keilaa kohden. Ensimmäisenä maaliin voittaa.';

  @override
  String get modeKubbDesc =>
      'Klassiset säännöt. Tyhjennä kenttä, sitten kuningas.';

  @override
  String modeNumberHint(int target) {
    return 'Pisteitä keilaa kohden. Ensimmäisenä $target:een voittaa.';
  }

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pelaajaa',
      one: '1 pelaaja',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'Nimet ovat valinnaisia. Napauta nimeä muuttaaksesi sen.';

  @override
  String get recentLabel => 'Viimeisimmät';

  @override
  String get teamsOffDesc => 'Jokainen pelaa itsekseen.';

  @override
  String get teamsOnDesc =>
      'Pisteet lasketaan joukkueittain. Napauta pilleriä siirtääksesi pelaajan.';

  @override
  String get swapTeams => 'Vaihda joukkueet';

  @override
  String moveToTeam(String name, String team) {
    return 'Siirrä $name joukkueeseen $team';
  }

  @override
  String get resetLabel => 'Palauta';

  @override
  String get targetScoreDesc => 'Osu tarkalleen voittaaksesi';

  @override
  String get backToLabel => 'Takaisin';

  @override
  String get backToDesc => 'Pisteet, kun ylität';

  @override
  String get eliminationDesc => 'Ohiheittoja peräkkäin ennen putoamista';

  @override
  String summaryFirstTo(int target) {
    return 'ensin $target:een';
  }

  @override
  String summaryBackTo(int reset) {
    return 'takaisin $reset:een';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'ulos $misses ohiheiton jälkeen';
  }

  @override
  String get summaryNoPenalty => 'ei rangaistusta';

  @override
  String get summaryNoElimination => 'ei putoamista';

  @override
  String get summaryInTeams => 'joukkueissa';

  @override
  String get editValueTitle => 'Syötä arvo';

  @override
  String renamePlayer(String name) {
    return 'Nimeä $name uudelleen';
  }
}
