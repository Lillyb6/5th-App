// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tagline => '为学习留出一点空间。';

  @override
  String get demoCredentials => '试用演示账号：demo / studyspace123';

  @override
  String get supabaseSignInHint => '登录或创建账号以将卡组同步到 Supabase。';

  @override
  String get signIn => '登录';

  @override
  String get createAccount => '创建账号';

  @override
  String get continueAsGuest => '以访客身份继续';

  @override
  String get localOnlyNotice => '账号和卡组仅保存在此设备上。此原型不使用服务器进行身份验证或同步。';

  @override
  String get supabaseNotice => '访客卡组仅保存在此设备上。登录账号的卡组会与 Supabase 同步。';

  @override
  String get username => '用户名';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get minimumUsername => '用户名至少需要 3 个字符';

  @override
  String get minimumPassword => '密码至少需要 8 个字符';

  @override
  String get passwordsMismatch => '两次输入的密码不一致';

  @override
  String get usernameTaken => '该用户名已被使用。';

  @override
  String get invalidCredentials => '用户名或密码错误。';

  @override
  String get emailInvalid => '请输入有效的电子邮箱地址';

  @override
  String get resendConfirmationEmail => '重新发送确认邮件';

  @override
  String get confirmationEmailSent => '已请求发送确认邮件。请检查收件箱和垃圾邮件文件夹，然后登录。';

  @override
  String get emailConfirmation => '请检查邮箱并确认账号，然后登录。';

  @override
  String authRequestError(String error) {
    return '无法完成账号请求：$error';
  }

  @override
  String accountStorageError(String error) {
    return '无法访问本地账号：$error';
  }

  @override
  String settingsSaveError(String error) {
    return '无法保存设置：$error';
  }

  @override
  String settingsLoadError(String error) {
    return '无法加载应用设置：$error';
  }

  @override
  String get deckLoadError => '无法加载已保存的卡组。请重启应用后再进行更改。';

  @override
  String supabaseDeckError(String error) {
    return '无法与 Supabase 同步卡组：$error';
  }

  @override
  String supabaseInitError(String error) {
    return '无法连接到 Supabase：$error';
  }

  @override
  String get needAccount => '还没有账号？注册';

  @override
  String get haveAccount => '已有账号？登录';

  @override
  String get back => '返回';

  @override
  String get create => '创建';

  @override
  String get createDeck => '创建卡组';

  @override
  String get importDeckTooltip => '导入卡组';

  @override
  String get timer => '计时器';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get darkMode => '深色模式';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get vietnamese => '越南语';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日语';

  @override
  String get dutch => '荷兰语';

  @override
  String get german => '德语';

  @override
  String hiUser(String username) {
    return '你好，$username';
  }

  @override
  String deckCount(int count) {
    return '$count 个卡组';
  }

  @override
  String flashcardCount(int count) {
    return '$count 张学习卡';
  }

  @override
  String minutesStudied(int count) {
    return '已学习 $count 分钟';
  }

  @override
  String get searchDecks => '搜索卡组';

  @override
  String get yourLibrary => '你的卡库';

  @override
  String get noDecksFound => '未找到卡组。创建一个卡组以开始学习。';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards 张卡 • 已学习 $minutes 分钟';
  }

  @override
  String get editDeck => '编辑卡组';

  @override
  String get exportDeck => '导出卡组';

  @override
  String get deckCopied => '卡组 JSON 已复制。可粘贴到文件中或分享以供导入。';

  @override
  String get flashcards => '学习卡';

  @override
  String get takeQuiz => '开始测验';

  @override
  String get newDeck => '新卡组';

  @override
  String get title => '标题';

  @override
  String cardNumber(int number) {
    return '第 $number 张卡';
  }

  @override
  String get removeCard => '删除卡片';

  @override
  String get term => '术语';

  @override
  String get definition => '定义';

  @override
  String get addCard => '添加卡片';

  @override
  String get saveDeck => '保存卡组';

  @override
  String get requiredText => '请输入内容';

  @override
  String get minimumTwoCards => '卡组至少需要 2 张卡片。';

  @override
  String get importDeck => '导入卡组';

  @override
  String get pasteDeckJson => '粘贴导出的卡组 JSON';

  @override
  String get cancel => '取消';

  @override
  String get import => '导入';

  @override
  String get invalidDeck => '卡组无效。请粘贴完整的 StudySpace 导出内容。';

  @override
  String get saveError => '无法在此设备上保存更改。';

  @override
  String get signOut => '退出登录';

  @override
  String get focusComplete => '专注时段已结束，休息一下吧！';

  @override
  String get sessionComplete => '学习结束';

  @override
  String retryMissed(int count) {
    return '重做 $count 张未掌握的卡';
  }

  @override
  String get backToLibrary => '返回卡库';

  @override
  String quizProgress(int current, int total) {
    return '测验 • $current/$total';
  }

  @override
  String studyProgress(int current, int total) {
    return '学习卡 • $current/$total';
  }

  @override
  String correctCount(int correct, int total) {
    return '答对 $correct/$total 题';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '记住 $correct/$total 张卡';
  }

  @override
  String get tapOrSwipe => '点击翻面 · 左滑：仍需学习 · 右滑：已掌握';

  @override
  String get whichTerm => '哪个术语与此定义相符？';

  @override
  String get correct => '正确！';

  @override
  String incorrectAnswer(String term) {
    return '不太对。正确术语是 $term。';
  }

  @override
  String get continueButton => '继续';

  @override
  String get flipCard => '翻转卡片';

  @override
  String get stillLearning => '还没掌握';

  @override
  String get gotIt => '掌握了';

  @override
  String get makeTimeToStudy => '安排学习时间';

  @override
  String get createDeckFirst => '请先创建卡组，然后回来开始计时学习。';

  @override
  String get studyDeck => '学习卡组';

  @override
  String get pomodoro => '番茄钟';

  @override
  String get focusMinutes => '专注 25 分钟';

  @override
  String minutes(int count) {
    return '$count 分钟';
  }

  @override
  String get timerDuration => '计时时长';

  @override
  String get studyWithCountdown => '使用顶部的倒计时学习卡片。';

  @override
  String get pauseTimer => '暂停专注计时器';

  @override
  String get startTimer => '开始专注计时器';

  @override
  String get resetTimer => '重置计时器';

  @override
  String studyTime(String duration) {
    return '学习时间 $duration';
  }

  @override
  String get openEnded => '开放式计时';

  @override
  String get openEndedDescription => '正向计时，按自己的节奏学习。';

  @override
  String get flowtime => 'Flowtime / Flowmodoro';

  @override
  String get flowtimeDescription => '自由专注，然后休息专注时长的五分之一。';

  @override
  String get takeBreak => '开始休息';

  @override
  String get resumeFocus => '开始下一轮专注';

  @override
  String get breakTimer => '休息';

  @override
  String get breakComplete => '休息结束。准备好继续专注了吗？';

  @override
  String get home => '首页';

  @override
  String get library => '学习库';

  @override
  String get yourLearningCorner => '你的学习小天地';

  @override
  String get homeDescription => '好奇心的温馨角落。几张卡片，一点专注，遇见更闪亮的自己。';

  @override
  String get decksCreated => '已创建卡组';

  @override
  String get statMinutesStudied => '已学习分钟';

  @override
  String get flashcardsCompleted => '已完成卡片';

  @override
  String get makeALittleProgress => '今天也进步一点点';

  @override
  String get beginStudyingHome => '开始学习！';

  @override
  String get chooseYourRhythm => '选择卡组，找到自己的节奏。';

  @override
  String get createNewDeck => '创建新卡组';

  @override
  String get libraryShortcut => '所有知识，汇聚一处。';

  @override
  String get createShortcut => '为下一个灵感安个家。';

  @override
  String get smallSteps => '小小进步，大大顿悟。';

  @override
  String get libraryDescription => '不断丰富的小小发现集。';

  @override
  String get studySession => '学习时段';

  @override
  String get findYourFlow => '找到你的节奏。';

  @override
  String get timerIntro => '一点专注，收获更多。选择你的步调。';

  @override
  String get chooseTimer => '选择计时器';

  @override
  String get flowtimeShort => 'Flowtime';

  @override
  String get pomodoroDescription => '一次专注一段时间。设置倒计时，安心学习。';

  @override
  String get focusSession => '专注时段';

  @override
  String get beginStudying => '开始学习';
}
