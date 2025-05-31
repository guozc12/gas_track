// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Levens Tracker';

  @override
  String get login => 'Inloggen';

  @override
  String get register => 'Registreren';

  @override
  String get logout => 'Uitloggen';

  @override
  String get aiAnalysis => 'AI-analyse';

  @override
  String get history => 'Geschiedenis';

  @override
  String get statistics => 'Statistieken & AI-analyse';

  @override
  String get continueWithGpt => 'Doorgaan met GPT...';

  @override
  String get notLoggedIn => 'Niet ingelogd';

  @override
  String get viewFullConversation => 'Volledig GPT-gesprek bekijken';

  @override
  String get hideFullConversation => 'Volledig gesprek verbergen';

  @override
  String get dataSummary => '📊 Samenvatting van de afgelopen week:';

  @override
  String get noData => 'Geen gegevens';

  @override
  String get add => 'Toevoegen';

  @override
  String get save => 'Opslaan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get selectType => 'Type selecteren';

  @override
  String get selectMeal => 'Maaltijdtype selecteren';

  @override
  String get selectDrink => 'Drank selecteren';

  @override
  String get selectPoop => 'Soort ontlasting selecteren';

  @override
  String get selectPee => 'Urinekleur selecteren';

  @override
  String get fart => 'Scheet';

  @override
  String get poop => 'Ontlasting';

  @override
  String get pee => 'Urine';

  @override
  String get meal => 'Maaltijd';

  @override
  String get drink => 'Drank';

  @override
  String get sound => 'Geluid';

  @override
  String get smell => 'Geur';

  @override
  String get consistency => 'Consistentie';

  @override
  String get color => 'Kleur';

  @override
  String get mealType => 'Maaltijdtype';

  @override
  String get earlyMeal => 'Ontbijt';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Diner';

  @override
  String get snack => 'Snack';

  @override
  String get stinky => 'Stinkend';

  @override
  String get notStinky => 'Niet stinkend';

  @override
  String get loud => 'Luid';

  @override
  String get silent => 'Stil';

  @override
  String get dry => 'Droog';

  @override
  String get normal => 'Normaal';

  @override
  String get loose => 'Los';

  @override
  String get dark => 'Donker';

  @override
  String get transparent => 'Transparant';

  @override
  String get user => 'Gebruiker';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => 'Maaltijdtype selecteren';

  @override
  String get selectSoundType => 'Geluidstype selecteren';

  @override
  String get selectSmellType => 'Geurtype selecteren';

  @override
  String get selectPoopConsistency => 'Consistentie van ontlasting selecteren';

  @override
  String get selectPeeColor => 'Urinekleur selecteren';

  @override
  String get iJustHadAFart => 'Ik heb net een scheet gelaten 💨';

  @override
  String get iJustHadAPoop => 'Ik heb net gepoept 💩';

  @override
  String get iJustHadAMeal => 'Ik heb net gegeten 🍽️';

  @override
  String get iJustHadADrink => 'Ik heb net iets gedronken 🥤';

  @override
  String get iJustHadAPee => 'Ik heb net geplast 💧';

  @override
  String get addEvent => 'Gebeurtenis toevoegen';

  @override
  String get editEvent => 'Gebeurtenis bewerken';

  @override
  String get time => 'Tijd';

  @override
  String get cancelSelectAll => 'Alles deselecteren';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get deleteSelected => 'Geselecteerde verwijderen';

  @override
  String get enterSelectionMode => 'Selectiemodus starten';

  @override
  String get addNewEvent => 'Nieuwe gebeurtenis toevoegen';

  @override
  String get viewGPTFullConversation => 'Volledig GPT-gesprek bekijken';

  @override
  String get continueGPTConversation => 'Doorgaan met GPT...';

  @override
  String get unknownValue => 'Onbekend';

  @override
  String get drinkedWater => 'Een glas water gedronken';

  @override
  String get byDay => 'Per dag';

  @override
  String get byWeek => 'Per week';

  @override
  String get byMonth => 'Per maand';

  @override
  String get byYear => 'Per jaar';

  @override
  String get selectDate => 'Datum selecteren';

  @override
  String get selectWeek => 'Week selecteren';

  @override
  String get selectMonth => 'Maand selecteren';

  @override
  String get selectYear => 'Jaar selecteren';

  @override
  String get noDataForDay => 'Geen gegevens voor deze dag';

  @override
  String get monday => 'Ma';

  @override
  String get tuesday => 'Di';

  @override
  String get wednesday => 'Wo';

  @override
  String get thursday => 'Do';

  @override
  String get friday => 'Vr';

  @override
  String get saturday => 'Za';

  @override
  String get sunday => 'Zo';

  @override
  String weekOf(Object week) {
    return 'Week $week';
  }

  @override
  String get month1 => 'Jan';

  @override
  String get month2 => 'Feb';

  @override
  String get month3 => 'Mrt';

  @override
  String get month4 => 'Apr';

  @override
  String get month5 => 'Mei';

  @override
  String get month6 => 'Jun';

  @override
  String get month7 => 'Jul';

  @override
  String get month8 => 'Aug';

  @override
  String get month9 => 'Sep';

  @override
  String get month10 => 'Okt';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dec';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type totaal $count keer, gemiddelde interval $interval min';
  }

  @override
  String get dailyCoverage => '📅 Dagelijkse dekking:';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice =>
      '⚠️ Opmerking: Statistieken kunnen onvolledig zijn door ontbrekende gegevens. GPT, analyseer zorgvuldig.';

  @override
  String get detailRecords => 'Gedetailleerde gegevens:';

  @override
  String get aiRequest =>
      'Geef alstublieft gezondheids- en lifestyle-advies op basis van bovenstaande frequenties en intervallen.';
}
