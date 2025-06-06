// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Life Tracker';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get history => 'History';

  @override
  String get statistics => 'Statistics & AI Analysis';

  @override
  String get continueWithGpt => 'Continue with GPT...';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get viewFullConversation => 'View full GPT conversation';

  @override
  String get hideFullConversation => 'Hide full conversation';

  @override
  String get dataSummary => 'Data summary for the past week:';

  @override
  String get noData => 'No data';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get selectType => 'Select type';

  @override
  String get selectMeal => 'Select meal type';

  @override
  String get selectDrink => 'Select drink';

  @override
  String get selectPoop => 'Select poop type';

  @override
  String get selectPee => 'Select pee color';

  @override
  String get fart => 'Fart';

  @override
  String get poop => 'Poop';

  @override
  String get pee => 'Pee';

  @override
  String get meal => 'Meal';

  @override
  String get drink => 'Drink';

  @override
  String get sound => 'Sound';

  @override
  String get smell => 'Smell';

  @override
  String get consistency => 'Consistency';

  @override
  String get color => 'Color';

  @override
  String get mealType => 'Meal type';

  @override
  String get earlyMeal => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get stinky => 'Stinky';

  @override
  String get notStinky => 'Not stinky';

  @override
  String get loud => 'Loud';

  @override
  String get silent => 'Silent';

  @override
  String get dry => 'Dry';

  @override
  String get normal => 'Normal';

  @override
  String get loose => 'Loose';

  @override
  String get dark => 'Dark';

  @override
  String get transparent => 'Transparent';

  @override
  String get user => 'User';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => 'Select meal type';

  @override
  String get selectSoundType => 'Select sound type';

  @override
  String get selectSmellType => 'Select smell type';

  @override
  String get selectPoopConsistency => 'Select poop consistency';

  @override
  String get selectPeeColor => 'Select pee color';

  @override
  String get iJustHadAFart => 'I just had a fart 💨';

  @override
  String get iJustHadAPoop => 'I just had a poop 💩';

  @override
  String get iJustHadAMeal => 'I just had a meal 🍽️';

  @override
  String get iJustHadADrink => 'I just had a drink 🥤';

  @override
  String get iJustHadAPee => 'I just had a pee 💧';

  @override
  String get addEvent => 'Add Event';

  @override
  String get editEvent => 'Edit Event';

  @override
  String get time => 'Time';

  @override
  String get cancelSelectAll => 'Cancel Select All';

  @override
  String get selectAll => 'Select All';

  @override
  String get deleteSelected => 'Delete Selected';

  @override
  String get enterSelectionMode => 'Enter Selection Mode';

  @override
  String get addNewEvent => 'Add New Event';

  @override
  String get viewGPTFullConversation => 'View full GPT conversation';

  @override
  String get continueGPTConversation => 'Continue with GPT...';

  @override
  String get unknownValue => 'Unknown';

  @override
  String get drinkedWater => 'Drank a glass of water';

  @override
  String get byDay => 'By Day';

  @override
  String get byWeek => 'By Week';

  @override
  String get byMonth => 'By Month';

  @override
  String get byYear => 'By Year';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectWeek => 'Select Week';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get selectYear => 'Select Year';

  @override
  String get noDataForDay => 'No data for this day';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String weekOf(Object week) {
    return 'Week $week';
  }

  @override
  String get month1 => 'Jan';

  @override
  String get month2 => 'Feb';

  @override
  String get month3 => 'Mar';

  @override
  String get month4 => 'Apr';

  @override
  String get month5 => 'May';

  @override
  String get month6 => 'Jun';

  @override
  String get month7 => 'Jul';

  @override
  String get month8 => 'Aug';

  @override
  String get month9 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dec';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type total $count times, average interval $interval min';
  }

  @override
  String get dailyCoverage => '📅 Daily coverage:';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice =>
      '⚠️ Note: The above statistics may be incomplete due to missing records. GPT, please analyze accordingly.';

  @override
  String get detailRecords => 'Detailed records:';

  @override
  String get aiRequest =>
      'Please provide health and lifestyle advice based on the above frequencies and intervals.';

  @override
  String get languageRestartNotice =>
      'You need to restart the app for the language change to take effect.';

  @override
  String get restart => 'Restart';
}
