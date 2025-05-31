// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi de Vie';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get logout => 'Déconnexion';

  @override
  String get aiAnalysis => 'Analyse IA';

  @override
  String get history => 'Historique';

  @override
  String get statistics => 'Statistiques & Analyse IA';

  @override
  String get continueWithGpt => 'Continuer avec GPT...';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get viewFullConversation => 'Voir toute la conversation GPT';

  @override
  String get hideFullConversation => 'Masquer la conversation complète';

  @override
  String get dataSummary => '📊 Résumé de la semaine passée :';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get selectType => 'Sélectionner le type';

  @override
  String get selectMeal => 'Sélectionner le type de repas';

  @override
  String get selectDrink => 'Sélectionner la boisson';

  @override
  String get selectPoop => 'Sélectionner le type de selles';

  @override
  String get selectPee => 'Sélectionner la couleur de l\'urine';

  @override
  String get fart => 'Pet';

  @override
  String get poop => 'Selles';

  @override
  String get pee => 'Urine';

  @override
  String get meal => 'Repas';

  @override
  String get drink => 'Boisson';

  @override
  String get sound => 'Son';

  @override
  String get smell => 'Odeur';

  @override
  String get consistency => 'Consistance';

  @override
  String get color => 'Couleur';

  @override
  String get mealType => 'Type de repas';

  @override
  String get earlyMeal => 'Petit-déjeuner';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get dinner => 'Dîner';

  @override
  String get snack => 'Snack';

  @override
  String get stinky => 'Malodorant';

  @override
  String get notStinky => 'Non malodorant';

  @override
  String get loud => 'Bruyant';

  @override
  String get silent => 'Silencieux';

  @override
  String get dry => 'Sec';

  @override
  String get normal => 'Normal';

  @override
  String get loose => 'Mou';

  @override
  String get dark => 'Foncé';

  @override
  String get transparent => 'Transparent';

  @override
  String get user => 'Utilisateur';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => 'Sélectionner le type de repas';

  @override
  String get selectSoundType => 'Sélectionner le type de son';

  @override
  String get selectSmellType => 'Sélectionner le type d\'odeur';

  @override
  String get selectPoopConsistency => 'Sélectionner la consistance des selles';

  @override
  String get selectPeeColor => 'Sélectionner la couleur de l\'urine';

  @override
  String get iJustHadAFart => 'Je viens de péter 💨';

  @override
  String get iJustHadAPoop => 'Je viens d\'aller à la selle 💩';

  @override
  String get iJustHadAMeal => 'Je viens de manger 🍽️';

  @override
  String get iJustHadADrink => 'Je viens de boire 🥤';

  @override
  String get iJustHadAPee => 'Je viens d\'uriner 💧';

  @override
  String get addEvent => 'Ajouter un événement';

  @override
  String get editEvent => 'Modifier l\'événement';

  @override
  String get time => 'Heure';

  @override
  String get cancelSelectAll => 'Tout désélectionner';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get deleteSelected => 'Supprimer la sélection';

  @override
  String get enterSelectionMode => 'Entrer en mode sélection';

  @override
  String get addNewEvent => 'Ajouter un nouvel événement';

  @override
  String get viewGPTFullConversation => 'Voir toute la conversation GPT';

  @override
  String get continueGPTConversation => 'Continuer avec GPT...';

  @override
  String get unknownValue => 'Inconnu';

  @override
  String get drinkedWater => 'J\'ai bu un verre d\'eau';

  @override
  String get byDay => 'Par jour';

  @override
  String get byWeek => 'Par semaine';

  @override
  String get byMonth => 'Par mois';

  @override
  String get byYear => 'Par année';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get selectWeek => 'Sélectionner la semaine';

  @override
  String get selectMonth => 'Sélectionner le mois';

  @override
  String get selectYear => 'Sélectionner l\'année';

  @override
  String get noDataForDay => 'Aucune donnée pour ce jour';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Jeu';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sam';

  @override
  String get sunday => 'Dim';

  @override
  String weekOf(Object week) {
    return 'Semaine $week';
  }

  @override
  String get month1 => 'Jan';

  @override
  String get month2 => 'Fév';

  @override
  String get month3 => 'Mar';

  @override
  String get month4 => 'Avr';

  @override
  String get month5 => 'Mai';

  @override
  String get month6 => 'Juin';

  @override
  String get month7 => 'Juil';

  @override
  String get month8 => 'Aoû';

  @override
  String get month9 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Déc';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type total $count fois, intervalle moyen $interval min';
  }

  @override
  String get dailyCoverage => '📅 Couverture quotidienne :';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice =>
      '⚠️ Remarque : Les statistiques peuvent être incomplètes en raison de données manquantes. GPT, analysez avec précaution.';

  @override
  String get detailRecords => 'Enregistrements détaillés :';

  @override
  String get aiRequest =>
      'Veuillez fournir des conseils de santé et de mode de vie basés sur les fréquences et intervalles ci-dessus.';
}
