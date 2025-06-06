// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '生活追踪';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get logout => '登出';

  @override
  String get aiAnalysis => 'AI分析';

  @override
  String get history => '历史记录';

  @override
  String get statistics => '数据统计与AI分析';

  @override
  String get continueWithGpt => '继续与GPT对话...';

  @override
  String get notLoggedIn => '未登录';

  @override
  String get viewFullConversation => '查看GPT完整对话';

  @override
  String get hideFullConversation => '隐藏完整对话';

  @override
  String get dataSummary => '📊 过去一周的记录摘要如下：';

  @override
  String get noData => '没有数据';

  @override
  String get add => '添加';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get selectType => '选择类型';

  @override
  String get selectMeal => '选择餐食类型';

  @override
  String get selectDrink => '选择饮品';

  @override
  String get selectPoop => '选择大便类型';

  @override
  String get selectPee => '选择尿液颜色';

  @override
  String get fart => '放屁';

  @override
  String get poop => '拉屎';

  @override
  String get pee => '尿尿';

  @override
  String get meal => '吃饭';

  @override
  String get drink => '喝水';

  @override
  String get sound => '声音';

  @override
  String get smell => '气味';

  @override
  String get consistency => '类型';

  @override
  String get color => '颜色';

  @override
  String get mealType => '餐别';

  @override
  String get earlyMeal => '早饭';

  @override
  String get lunch => '午饭';

  @override
  String get dinner => '晚饭';

  @override
  String get snack => '零食';

  @override
  String get stinky => '臭';

  @override
  String get notStinky => '不臭';

  @override
  String get loud => '有声';

  @override
  String get silent => '无声';

  @override
  String get dry => '干';

  @override
  String get normal => '正常';

  @override
  String get loose => '拉稀';

  @override
  String get dark => '深色';

  @override
  String get transparent => '透明';

  @override
  String get user => '用户';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => '选择餐食类型';

  @override
  String get selectSoundType => '选择声音类型';

  @override
  String get selectSmellType => '选择气味类型';

  @override
  String get selectPoopConsistency => '选择大便类型';

  @override
  String get selectPeeColor => '选择尿液颜色';

  @override
  String get iJustHadAFart => '我刚放了一个屁 💨';

  @override
  String get iJustHadAPoop => '我刚拉了一坨屎 💩';

  @override
  String get iJustHadAMeal => '我刚吃了一顿饭 🍽️';

  @override
  String get iJustHadADrink => '我刚喝了一杯水 🥤';

  @override
  String get iJustHadAPee => '我刚尿了一泡尿 💧';

  @override
  String get addEvent => '添加事件';

  @override
  String get editEvent => '编辑事件';

  @override
  String get time => '时间';

  @override
  String get cancelSelectAll => '取消全选';

  @override
  String get selectAll => '全选';

  @override
  String get deleteSelected => '删除选中记录';

  @override
  String get enterSelectionMode => '进入选择模式';

  @override
  String get addNewEvent => '添加新事件';

  @override
  String get viewGPTFullConversation => '查看 GPT 完整对话';

  @override
  String get continueGPTConversation => '继续与 GPT 对话...';

  @override
  String get unknownValue => '未知';

  @override
  String get drinkedWater => '喝了一杯水';

  @override
  String get byDay => '按天';

  @override
  String get byWeek => '按周';

  @override
  String get byMonth => '按月';

  @override
  String get byYear => '按年';

  @override
  String get selectDate => '选择日期';

  @override
  String get selectWeek => '选择周';

  @override
  String get selectMonth => '选择月份';

  @override
  String get selectYear => '选择年份';

  @override
  String get noDataForDay => '该日无数据';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

  @override
  String get sunday => '周日';

  @override
  String weekOf(Object week) {
    return '第$week周';
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
    return '▶️ $type 共计 $count 次，平均间隔 $interval 分钟';
  }

  @override
  String get dailyCoverage => '📅 每日记录覆盖情况：';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice => '⚠️ 注意：以上统计可能因用户遗漏记录而不完全，GPT 请结合这一点审慎分析。';

  @override
  String get detailRecords => '详细记录如下：';

  @override
  String get aiRequest => '请基于上述不同类型的记录频率与间隔，为用户提供健康与生活方式建议。';

  @override
  String get languageRestartNotice => '切换语言后需要重启App才能生效。';

  @override
  String get restart => '重启';
}
