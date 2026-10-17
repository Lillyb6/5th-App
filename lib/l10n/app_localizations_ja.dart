// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tagline => '学びのための小さなスペースを作りましょう。';

  @override
  String get demoCredentials => 'デモアカウントを試す: demo / studyspace123';

  @override
  String get signIn => 'ログイン';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get continueAsGuest => 'ゲストとして続ける';

  @override
  String get localOnlyNotice =>
      'アカウントとデッキはこの端末にのみ保存されます。この試作版ではサーバー認証や同期は行いません。';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワードを確認';

  @override
  String get minimumUsername => 'ユーザー名は3文字以上にしてください';

  @override
  String get minimumPassword => 'パスワードは8文字以上にしてください';

  @override
  String get passwordsMismatch => 'パスワードが一致しません';

  @override
  String get usernameTaken => 'このユーザー名はすでに使用されています。';

  @override
  String get invalidCredentials => 'ユーザー名またはパスワードが正しくありません。';

  @override
  String accountStorageError(String error) {
    return 'ローカルアカウントにアクセスできません: $error';
  }

  @override
  String settingsSaveError(String error) {
    return '設定を保存できませんでした: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'アプリの設定を読み込めませんでした: $error';
  }

  @override
  String get deckLoadError => '保存済みデッキを読み込めませんでした。変更する前にアプリを再起動してください。';

  @override
  String get needAccount => 'アカウントをお持ちでない場合は登録';

  @override
  String get haveAccount => 'アカウントをお持ちの場合はログイン';

  @override
  String get back => '戻る';

  @override
  String get create => '作成';

  @override
  String get createDeck => 'デッキを作成';

  @override
  String get importDeckTooltip => 'デッキをインポート';

  @override
  String get timer => 'タイマー';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get english => '英語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get vietnamese => 'ベトナム語';

  @override
  String get chinese => '中国語';

  @override
  String get japanese => '日本語';

  @override
  String get dutch => 'オランダ語';

  @override
  String get german => 'ドイツ語';

  @override
  String hiUser(String username) {
    return 'こんにちは、$usernameさん';
  }

  @override
  String deckCount(int count) {
    return '$count 個のデッキ';
  }

  @override
  String flashcardCount(int count) {
    return '$count 枚のフラッシュカード';
  }

  @override
  String minutesStudied(int count) {
    return '学習時間 $count 分';
  }

  @override
  String get searchDecks => 'デッキを検索';

  @override
  String get yourLibrary => 'マイライブラリ';

  @override
  String get noDecksFound => 'デッキが見つかりません。デッキを作成して始めましょう。';

  @override
  String cardsStudied(int cards, int minutes) {
    return 'カード $cards 枚 • 学習時間 $minutes 分';
  }

  @override
  String get editDeck => 'デッキを編集';

  @override
  String get exportDeck => 'デッキをエクスポート';

  @override
  String get deckCopied => 'デッキのJSONをコピーしました。ファイルに貼り付けるか、共有してインポートできます。';

  @override
  String get flashcards => 'フラッシュカード';

  @override
  String get takeQuiz => 'クイズに挑戦';

  @override
  String get newDeck => '新しいデッキ';

  @override
  String get title => 'タイトル';

  @override
  String cardNumber(int number) {
    return '$number 枚目のカード';
  }

  @override
  String get removeCard => 'カードを削除';

  @override
  String get term => '用語';

  @override
  String get definition => '定義';

  @override
  String get addCard => 'カードを追加';

  @override
  String get saveDeck => 'デッキを保存';

  @override
  String get requiredText => '文字を入力してください';

  @override
  String get minimumTwoCards => 'デッキには2枚以上のカードが必要です。';

  @override
  String get importDeck => 'デッキをインポート';

  @override
  String get pasteDeckJson => 'エクスポートしたデッキJSONを貼り付け';

  @override
  String get cancel => 'キャンセル';

  @override
  String get import => 'インポート';

  @override
  String get invalidDeck => 'デッキが無効です。StudySpaceの完全なエクスポートを貼り付けてください。';

  @override
  String get saveError => 'この端末に変更を保存できませんでした。';

  @override
  String get signOut => 'ログアウト';

  @override
  String get focusComplete => '集中セッションが終了しました。休憩しましょう！';

  @override
  String get sessionComplete => 'セッション完了';

  @override
  String retryMissed(int count) {
    return '間違えたカード $count 枚を再挑戦';
  }

  @override
  String get backToLibrary => 'ライブラリに戻る';

  @override
  String quizProgress(int current, int total) {
    return 'クイズ • $current/$total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'フラッシュカード • $current/$total';
  }

  @override
  String correctCount(int correct, int total) {
    return '$total 問中 $correct 問正解';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '$total 枚中 $correct 枚を記憶';
  }

  @override
  String get tapOrSwipe => 'タップまたはスワイプしてカードをめくる';

  @override
  String get whichTerm => 'この定義に当てはまる用語はどれですか？';

  @override
  String get correct => '正解！';

  @override
  String incorrectAnswer(String term) {
    return '違います。正しい用語は $term です。';
  }

  @override
  String get continueButton => '続ける';

  @override
  String get flipCard => 'カードをめくる';

  @override
  String get stillLearning => 'まだ覚えていない';

  @override
  String get gotIt => '覚えた';

  @override
  String get makeTimeToStudy => '学習時間を作りましょう';

  @override
  String get createDeckFirst => 'まずデッキを作成してから、タイマー付き学習を始めましょう。';

  @override
  String get studyDeck => '学習デッキ';

  @override
  String get pomodoro => 'ポモドーロ';

  @override
  String get focusMinutes => '25分間集中';

  @override
  String minutes(int count) {
    return '$count 分';
  }

  @override
  String get timerDuration => 'タイマー時間';

  @override
  String get studyWithCountdown => '画面上部のカウントダウンでカードを学習します。';

  @override
  String get pauseTimer => '集中タイマーを一時停止';

  @override
  String get startTimer => '集中タイマーを開始';

  @override
  String get resetTimer => 'タイマーをリセット';

  @override
  String studyTime(String duration) {
    return '学習時間 $duration';
  }
}
