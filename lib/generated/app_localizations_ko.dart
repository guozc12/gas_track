// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '라이프 트래커';

  @override
  String get login => '로그인';

  @override
  String get register => '회원가입';

  @override
  String get logout => '로그아웃';

  @override
  String get aiAnalysis => 'AI 분석';

  @override
  String get history => '기록';

  @override
  String get statistics => '통계 및 AI 분석';

  @override
  String get continueWithGpt => 'GPT와 계속하기...';

  @override
  String get notLoggedIn => '로그인되지 않음';

  @override
  String get viewFullConversation => 'GPT 전체 대화 보기';

  @override
  String get hideFullConversation => '전체 대화 숨기기';

  @override
  String get dataSummary => '📊 지난 1주일 요약:';

  @override
  String get noData => '데이터 없음';

  @override
  String get add => '추가';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get selectType => '유형 선택';

  @override
  String get selectMeal => '식사 유형 선택';

  @override
  String get selectDrink => '음료 선택';

  @override
  String get selectPoop => '대변 유형 선택';

  @override
  String get selectPee => '소변 색상 선택';

  @override
  String get fart => '방귀';

  @override
  String get poop => '대변';

  @override
  String get pee => '소변';

  @override
  String get meal => '식사';

  @override
  String get drink => '음료';

  @override
  String get sound => '소리';

  @override
  String get smell => '냄새';

  @override
  String get consistency => '상태';

  @override
  String get color => '색상';

  @override
  String get mealType => '식사 유형';

  @override
  String get earlyMeal => '아침';

  @override
  String get lunch => '점심';

  @override
  String get dinner => '저녁';

  @override
  String get snack => '간식';

  @override
  String get stinky => '냄새남';

  @override
  String get notStinky => '냄새 안남';

  @override
  String get loud => '시끄러움';

  @override
  String get silent => '조용함';

  @override
  String get dry => '건조함';

  @override
  String get normal => '보통';

  @override
  String get loose => '묽음';

  @override
  String get dark => '진함';

  @override
  String get transparent => '투명';

  @override
  String get user => '사용자';

  @override
  String get assistant => 'GPT';

  @override
  String get selectMealType => '식사 유형 선택';

  @override
  String get selectSoundType => '소리 유형 선택';

  @override
  String get selectSmellType => '냄새 유형 선택';

  @override
  String get selectPoopConsistency => '대변 상태 선택';

  @override
  String get selectPeeColor => '소변 색상 선택';

  @override
  String get iJustHadAFart => '방귀를 꼈어요 💨';

  @override
  String get iJustHadAPoop => '대변을 봤어요 💩';

  @override
  String get iJustHadAMeal => '식사를 했어요 🍽️';

  @override
  String get iJustHadADrink => '음료를 마셨어요 🥤';

  @override
  String get iJustHadAPee => '소변을 봤어요 💧';

  @override
  String get addEvent => '이벤트 추가';

  @override
  String get editEvent => '이벤트 수정';

  @override
  String get time => '시간';

  @override
  String get cancelSelectAll => '전체 선택 해제';

  @override
  String get selectAll => '전체 선택';

  @override
  String get deleteSelected => '선택 삭제';

  @override
  String get enterSelectionMode => '선택 모드 진입';

  @override
  String get addNewEvent => '새 이벤트 추가';

  @override
  String get viewGPTFullConversation => 'GPT 전체 대화 보기';

  @override
  String get continueGPTConversation => 'GPT와 계속하기...';

  @override
  String get unknownValue => '알 수 없음';

  @override
  String get drinkedWater => '물 한 잔 마셨음';

  @override
  String get byDay => '일별';

  @override
  String get byWeek => '주별';

  @override
  String get byMonth => '월별';

  @override
  String get byYear => '연별';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get selectWeek => '주 선택';

  @override
  String get selectMonth => '월 선택';

  @override
  String get selectYear => '연도 선택';

  @override
  String get noDataForDay => '이 날의 데이터가 없습니다';

  @override
  String get monday => '월';

  @override
  String get tuesday => '화';

  @override
  String get wednesday => '수';

  @override
  String get thursday => '목';

  @override
  String get friday => '금';

  @override
  String get saturday => '토';

  @override
  String get sunday => '일';

  @override
  String weekOf(Object week) {
    return '$week주차';
  }

  @override
  String get month1 => '1월';

  @override
  String get month2 => '2월';

  @override
  String get month3 => '3월';

  @override
  String get month4 => '4월';

  @override
  String get month5 => '5월';

  @override
  String get month6 => '6월';

  @override
  String get month7 => '7월';

  @override
  String get month8 => '8월';

  @override
  String get month9 => '9월';

  @override
  String get month10 => '10월';

  @override
  String get month11 => '11월';

  @override
  String get month12 => '12월';

  @override
  String typeSummary(Object count, Object interval, Object type) {
    return '▶️ $type 총 $count회, 평균 간격 $interval분';
  }

  @override
  String get dailyCoverage => '📅 일별 커버리지:';

  @override
  String get covered => '✅';

  @override
  String get notCovered => '❌';

  @override
  String get aiNotice =>
      '⚠️ 참고: 통계는 누락된 기록으로 인해 불완전할 수 있습니다. GPT는 이 점을 고려해 분석하세요.';

  @override
  String get detailRecords => '상세 기록:';

  @override
  String get aiRequest => '위 빈도와 간격을 바탕으로 건강 및 라이프스타일 조언을 해주세요.';

  @override
  String get languageRestartNotice =>
      'You need to restart the app for the language change to take effect.';

  @override
  String get restart => 'Restart';
}
