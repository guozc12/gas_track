// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rastreador de Vida';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get aiAnalysis => 'Análisis de IA';

  @override
  String get history => 'Historial';

  @override
  String get statistics => 'Estadísticas y Análisis de IA';

  @override
  String get continueWithGpt => 'Continuar con GPT...';

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get viewFullConversation => 'Ver conversación completa de GPT';

  @override
  String get hideFullConversation => 'Ocultar conversación completa';

  @override
  String get dataSummary => '📊 Resumen de la última semana:';

  @override
  String get noData => 'Sin datos';

  @override
  String get add => 'Agregar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get selectType => 'Seleccionar tipo';

  @override
  String get selectMeal => 'Seleccionar tipo de comida';

  @override
  String get selectDrink => 'Seleccionar bebida';

  @override
  String get selectPoop => 'Seleccionar tipo de heces';

  @override
  String get selectPee => 'Seleccionar color de orina';

  @override
  String get fart => 'Pedos';

  @override
  String get poop => 'Heces';

  @override
  String get pee => 'Orina';

  @override
  String get meal => 'Comida';

  @override
  String get drink => 'Bebida';

  @override
  String get sound => 'Sonido';

  @override
  String get smell => 'Olor';

  @override
  String get consistency => 'Consistencia';

  @override
  String get color => 'Color';

  @override
  String get mealType => 'Tipo de comida';

  @override
  String get earlyMeal => 'Desayuno';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get dinner => 'Cena';

  @override
  String get snack => 'Merienda';

  @override
  String get stinky => 'Apestoso';

  @override
  String get notStinky => 'No apestoso';

  @override
  String get loud => 'Ruidoso';

  @override
  String get silent => 'Silencioso';

  @override
  String get dry => 'Seco';

  @override
  String get normal => 'Normal';

  @override
  String get loose => 'Suave';

  @override
  String get dark => 'Oscuro';

  @override
  String get transparent => 'Transparente';

  @override
  String get user => 'Usuario';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => 'Seleccionar tipo de comida';

  @override
  String get selectSoundType => 'Seleccionar tipo de sonido';

  @override
  String get selectSmellType => 'Seleccionar tipo de olor';

  @override
  String get selectPoopConsistency => 'Seleccionar consistencia de heces';

  @override
  String get selectPeeColor => 'Seleccionar color de orina';

  @override
  String get iJustHadAFart => 'Acabo de tirarme un pedo 💨';

  @override
  String get iJustHadAPoop => 'Acabo de hacer caca 💩';

  @override
  String get iJustHadAMeal => 'Acabo de comer 🍽️';

  @override
  String get iJustHadADrink => 'Acabo de beber 🥤';

  @override
  String get iJustHadAPee => 'Acabo de orinar 💧';

  @override
  String get addEvent => 'Agregar evento';

  @override
  String get editEvent => 'Editar evento';

  @override
  String get time => 'Hora';

  @override
  String get cancelSelectAll => 'Cancelar selección';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get deleteSelected => 'Eliminar seleccionados';

  @override
  String get enterSelectionMode => 'Entrar en modo de selección';

  @override
  String get addNewEvent => 'Agregar nuevo evento';

  @override
  String get viewGPTFullConversation => 'Ver conversación completa de GPT';

  @override
  String get continueGPTConversation => 'Continuar con GPT...';

  @override
  String get unknownValue => 'Desconocido';

  @override
  String get drinkedWater => 'Bebí un vaso de agua';

  @override
  String get byDay => 'Por día';

  @override
  String get byWeek => 'Por semana';

  @override
  String get byMonth => 'Por mes';

  @override
  String get byYear => 'Por año';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectWeek => 'Seleccionar semana';

  @override
  String get selectMonth => 'Seleccionar mes';

  @override
  String get selectYear => 'Seleccionar año';

  @override
  String get noDataForDay => 'Sin datos para este día';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mié';

  @override
  String get thursday => 'Jue';

  @override
  String get friday => 'Vie';

  @override
  String get saturday => 'Sáb';

  @override
  String get sunday => 'Dom';

  @override
  String weekOf(Object week) {
    return 'Semana $week';
  }

  @override
  String get month1 => 'Ene';

  @override
  String get month2 => 'Feb';

  @override
  String get month3 => 'Mar';

  @override
  String get month4 => 'Abr';

  @override
  String get month5 => 'May';

  @override
  String get month6 => 'Jun';

  @override
  String get month7 => 'Jul';

  @override
  String get month8 => 'Ago';

  @override
  String get month9 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dic';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type total $count veces, intervalo promedio $interval min';
  }

  @override
  String get dailyCoverage => '📅 Cobertura diaria:';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice =>
      '⚠️ Nota: Las estadísticas pueden estar incompletas por registros faltantes. GPT, analiza con precaución.';

  @override
  String get detailRecords => 'Registros detallados:';

  @override
  String get aiRequest =>
      'Por favor, proporciona consejos de salud y estilo de vida basados en las frecuencias e intervalos anteriores.';

  @override
  String get languageRestartNotice =>
      'You need to restart the app for the language change to take effect.';

  @override
  String get restart => 'Restart';
}
