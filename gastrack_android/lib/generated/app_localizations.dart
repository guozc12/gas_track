import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Tracker'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics & AI Analysis'**
  String get statistics;

  /// No description provided for @continueWithGpt.
  ///
  /// In en, this message translates to:
  /// **'Continue with GPT...'**
  String get continueWithGpt;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @viewFullConversation.
  ///
  /// In en, this message translates to:
  /// **'View full GPT conversation'**
  String get viewFullConversation;

  /// No description provided for @hideFullConversation.
  ///
  /// In en, this message translates to:
  /// **'Hide full conversation'**
  String get hideFullConversation;

  /// No description provided for @dataSummary.
  ///
  /// In en, this message translates to:
  /// **'Data summary for the past week:'**
  String get dataSummary;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @selectMeal.
  ///
  /// In en, this message translates to:
  /// **'Select meal type'**
  String get selectMeal;

  /// No description provided for @selectDrink.
  ///
  /// In en, this message translates to:
  /// **'Select drink'**
  String get selectDrink;

  /// No description provided for @selectPoop.
  ///
  /// In en, this message translates to:
  /// **'Select poop type'**
  String get selectPoop;

  /// No description provided for @selectPee.
  ///
  /// In en, this message translates to:
  /// **'Select pee color'**
  String get selectPee;

  /// No description provided for @fart.
  ///
  /// In en, this message translates to:
  /// **'Fart'**
  String get fart;

  /// No description provided for @poop.
  ///
  /// In en, this message translates to:
  /// **'Poop'**
  String get poop;

  /// No description provided for @pee.
  ///
  /// In en, this message translates to:
  /// **'Pee'**
  String get pee;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @smell.
  ///
  /// In en, this message translates to:
  /// **'Smell'**
  String get smell;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get mealType;

  /// No description provided for @earlyMeal.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get earlyMeal;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @stinky.
  ///
  /// In en, this message translates to:
  /// **'Stinky'**
  String get stinky;

  /// No description provided for @notStinky.
  ///
  /// In en, this message translates to:
  /// **'Not stinky'**
  String get notStinky;

  /// No description provided for @loud.
  ///
  /// In en, this message translates to:
  /// **'Loud'**
  String get loud;

  /// No description provided for @silent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get silent;

  /// No description provided for @dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @loose.
  ///
  /// In en, this message translates to:
  /// **'Loose'**
  String get loose;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @transparent.
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get transparent;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'GPT'**
  String get assistant;

  /// No description provided for @selectMealType.
  ///
  /// In en, this message translates to:
  /// **'Select meal type'**
  String get selectMealType;

  /// No description provided for @selectSoundType.
  ///
  /// In en, this message translates to:
  /// **'Select sound type'**
  String get selectSoundType;

  /// No description provided for @selectSmellType.
  ///
  /// In en, this message translates to:
  /// **'Select smell type'**
  String get selectSmellType;

  /// No description provided for @selectPoopConsistency.
  ///
  /// In en, this message translates to:
  /// **'Select poop consistency'**
  String get selectPoopConsistency;

  /// No description provided for @selectPeeColor.
  ///
  /// In en, this message translates to:
  /// **'Select pee color'**
  String get selectPeeColor;

  /// No description provided for @iJustHadAFart.
  ///
  /// In en, this message translates to:
  /// **'I just had a fart 💨'**
  String get iJustHadAFart;

  /// No description provided for @iJustHadAPoop.
  ///
  /// In en, this message translates to:
  /// **'I just had a poop 💩'**
  String get iJustHadAPoop;

  /// No description provided for @iJustHadAMeal.
  ///
  /// In en, this message translates to:
  /// **'I just had a meal 🍽️'**
  String get iJustHadAMeal;

  /// No description provided for @iJustHadADrink.
  ///
  /// In en, this message translates to:
  /// **'I just had a drink 🥤'**
  String get iJustHadADrink;

  /// No description provided for @iJustHadAPee.
  ///
  /// In en, this message translates to:
  /// **'I just had a pee 💧'**
  String get iJustHadAPee;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @cancelSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Cancel Select All'**
  String get cancelSelectAll;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @enterSelectionMode.
  ///
  /// In en, this message translates to:
  /// **'Enter Selection Mode'**
  String get enterSelectionMode;

  /// No description provided for @addNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Add New Event'**
  String get addNewEvent;

  /// No description provided for @viewGPTFullConversation.
  ///
  /// In en, this message translates to:
  /// **'View full GPT conversation'**
  String get viewGPTFullConversation;

  /// No description provided for @continueGPTConversation.
  ///
  /// In en, this message translates to:
  /// **'Continue with GPT...'**
  String get continueGPTConversation;

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownValue;

  /// No description provided for @drinkedWater.
  ///
  /// In en, this message translates to:
  /// **'Drank a glass of water'**
  String get drinkedWater;

  /// No description provided for @byDay.
  ///
  /// In en, this message translates to:
  /// **'By Day'**
  String get byDay;

  /// No description provided for @byWeek.
  ///
  /// In en, this message translates to:
  /// **'By Week'**
  String get byWeek;

  /// No description provided for @byMonth.
  ///
  /// In en, this message translates to:
  /// **'By Month'**
  String get byMonth;

  /// No description provided for @byYear.
  ///
  /// In en, this message translates to:
  /// **'By Year'**
  String get byYear;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectWeek.
  ///
  /// In en, this message translates to:
  /// **'Select Week'**
  String get selectWeek;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @noDataForDay.
  ///
  /// In en, this message translates to:
  /// **'No data for this day'**
  String get noDataForDay;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String weekOf(Object week);

  /// No description provided for @month1.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get month1;

  /// No description provided for @month2.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get month2;

  /// No description provided for @month3.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get month3;

  /// No description provided for @month4.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get month4;

  /// No description provided for @month5.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month5;

  /// No description provided for @month6.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get month6;

  /// No description provided for @month7.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get month7;

  /// No description provided for @month8.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get month8;

  /// No description provided for @month9.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get month9;

  /// No description provided for @month10.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get month10;

  /// No description provided for @month11.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get month11;

  /// No description provided for @month12.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get month12;

  /// No description provided for @typeSummary.
  ///
  /// In en, this message translates to:
  /// **'▶️ {type} total {count} times, average interval {interval} min'**
  String typeSummary(Object count, Object interval, Object type);

  /// No description provided for @dailyCoverage.
  ///
  /// In en, this message translates to:
  /// **'📅 Daily coverage:'**
  String get dailyCoverage;

  /// No description provided for @covered.
  ///
  /// In en, this message translates to:
  /// **'✅'**
  String get covered;

  /// No description provided for @notCovered.
  ///
  /// In en, this message translates to:
  /// **'❌'**
  String get notCovered;

  /// No description provided for @aiNotice.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Note: The above statistics may be incomplete due to missing records. GPT, please analyze accordingly.'**
  String get aiNotice;

  /// No description provided for @detailRecords.
  ///
  /// In en, this message translates to:
  /// **'Detailed records:'**
  String get detailRecords;

  /// No description provided for @aiRequest.
  ///
  /// In en, this message translates to:
  /// **'Please provide health and lifestyle advice based on the above frequencies and intervals.'**
  String get aiRequest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'nl',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
