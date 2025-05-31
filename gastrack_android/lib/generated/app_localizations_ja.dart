// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ライフトラッカー';

  @override
  String get login => 'ログイン';

  @override
  String get register => '登録';

  @override
  String get logout => 'ログアウト';

  @override
  String get aiAnalysis => 'AI分析';

  @override
  String get history => '履歴';

  @override
  String get statistics => '統計とAI分析';

  @override
  String get continueWithGpt => 'GPTと続ける...';

  @override
  String get notLoggedIn => '未ログイン';

  @override
  String get viewFullConversation => 'GPTの全会話を見る';

  @override
  String get hideFullConversation => '全会話を隠す';

  @override
  String get dataSummary => '📊 過去1週間の記録サマリー：';

  @override
  String get noData => 'データなし';

  @override
  String get add => '追加';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get selectType => 'タイプを選択';

  @override
  String get selectMeal => '食事タイプを選択';

  @override
  String get selectDrink => '飲み物を選択';

  @override
  String get selectPoop => 'うんちタイプを選択';

  @override
  String get selectPee => 'おしっこ色を選択';

  @override
  String get fart => 'おなら';

  @override
  String get poop => 'うんち';

  @override
  String get pee => 'おしっこ';

  @override
  String get meal => '食事';

  @override
  String get drink => '飲み物';

  @override
  String get sound => '音';

  @override
  String get smell => 'におい';

  @override
  String get consistency => '状態';

  @override
  String get color => '色';

  @override
  String get mealType => '食事タイプ';

  @override
  String get earlyMeal => '朝食';

  @override
  String get lunch => '昼食';

  @override
  String get dinner => '夕食';

  @override
  String get snack => 'おやつ';

  @override
  String get stinky => 'くさい';

  @override
  String get notStinky => 'くさくない';

  @override
  String get loud => '大きい音';

  @override
  String get silent => '静か';

  @override
  String get dry => '乾燥';

  @override
  String get normal => '普通';

  @override
  String get loose => 'ゆるい';

  @override
  String get dark => '濃い';

  @override
  String get transparent => '透明';

  @override
  String get user => 'ユーザー';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => '食事タイプを選択';

  @override
  String get selectSoundType => '音タイプを選択';

  @override
  String get selectSmellType => 'においタイプを選択';

  @override
  String get selectPoopConsistency => 'うんちの状態を選択';

  @override
  String get selectPeeColor => 'おしっこの色を選択';

  @override
  String get iJustHadAFart => 'おならをした 💨';

  @override
  String get iJustHadAPoop => 'うんちをした 💩';

  @override
  String get iJustHadAMeal => '食事をした 🍽️';

  @override
  String get iJustHadADrink => '飲み物を飲んだ 🥤';

  @override
  String get iJustHadAPee => 'おしっこをした 💧';

  @override
  String get addEvent => 'イベント追加';

  @override
  String get editEvent => 'イベント編集';

  @override
  String get time => '時間';

  @override
  String get cancelSelectAll => '全選択解除';

  @override
  String get selectAll => '全選択';

  @override
  String get deleteSelected => '選択を削除';

  @override
  String get enterSelectionMode => '選択モードに入る';

  @override
  String get addNewEvent => '新しいイベントを追加';

  @override
  String get viewGPTFullConversation => 'GPTの全会話を見る';

  @override
  String get continueGPTConversation => 'GPTと続ける...';

  @override
  String get unknownValue => '不明';

  @override
  String get drinkedWater => 'コップ一杯の水を飲んだ';

  @override
  String get byDay => '日別';

  @override
  String get byWeek => '週別';

  @override
  String get byMonth => '月別';

  @override
  String get byYear => '年別';

  @override
  String get selectDate => '日付を選択';

  @override
  String get selectWeek => '週を選択';

  @override
  String get selectMonth => '月を選択';

  @override
  String get selectYear => '年を選択';

  @override
  String get noDataForDay => 'この日のデータはありません';

  @override
  String get monday => '月';

  @override
  String get tuesday => '火';

  @override
  String get wednesday => '水';

  @override
  String get thursday => '木';

  @override
  String get friday => '金';

  @override
  String get saturday => '土';

  @override
  String get sunday => '日';

  @override
  String weekOf(Object week) {
    return '第$week週';
  }

  @override
  String get month1 => '1月';

  @override
  String get month2 => '2月';

  @override
  String get month3 => '3月';

  @override
  String get month4 => '4月';

  @override
  String get month5 => '5月';

  @override
  String get month6 => '6月';

  @override
  String get month7 => '7月';

  @override
  String get month8 => '8月';

  @override
  String get month9 => '9月';

  @override
  String get month10 => '10月';

  @override
  String get month11 => '11月';

  @override
  String get month12 => '12月';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type 合計 $count 回、平均間隔 $interval 分';
  }

  @override
  String get dailyCoverage => '📅 日別カバレッジ：';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice => '⚠️ 注意：上記の統計は記録漏れにより不完全な場合があります。GPTはこの点を考慮して分析してください。';

  @override
  String get detailRecords => '詳細記録：';

  @override
  String get aiRequest => '上記の頻度と間隔に基づき、健康とライフスタイルのアドバイスをお願いします。';
}
