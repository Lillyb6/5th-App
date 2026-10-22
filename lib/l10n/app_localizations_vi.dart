// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tagline => 'Dành một chút không gian cho việc học.';

  @override
  String get demoCredentials => 'Dùng thử tài khoản mẫu: demo / studyspace123';

  @override
  String get supabaseSignInHint =>
      'Đăng nhập hoặc tạo tài khoản để đồng bộ bộ thẻ với Supabase.';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get continueAsGuest => 'Tiếp tục với tư cách khách';

  @override
  String get localOnlyNotice =>
      'Tài khoản và bộ thẻ chỉ được lưu trên thiết bị này. Bản thử nghiệm không dùng máy chủ để xác thực hoặc đồng bộ.';

  @override
  String get supabaseNotice =>
      'Bộ thẻ khách chỉ lưu trên thiết bị này. Bộ thẻ của tài khoản đã đăng nhập được đồng bộ với Supabase.';

  @override
  String get username => 'Tên người dùng';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get minimumUsername => 'Tên người dùng cần có ít nhất 3 ký tự';

  @override
  String get minimumPassword => 'Mật khẩu cần có ít nhất 8 ký tự';

  @override
  String get passwordsMismatch => 'Mật khẩu không khớp';

  @override
  String get usernameTaken => 'Tên người dùng này đã được sử dụng.';

  @override
  String get invalidCredentials => 'Tên người dùng hoặc mật khẩu không đúng.';

  @override
  String get emailInvalid => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get emailConfirmation =>
      'Hãy kiểm tra email để xác nhận tài khoản, sau đó đăng nhập.';

  @override
  String authRequestError(String error) {
    return 'Không thể hoàn tất yêu cầu tài khoản: $error';
  }

  @override
  String accountStorageError(String error) {
    return 'Không thể truy cập tài khoản trên thiết bị: $error';
  }

  @override
  String settingsSaveError(String error) {
    return 'Không thể lưu cài đặt: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'Không thể tải cài đặt ứng dụng: $error';
  }

  @override
  String get deckLoadError =>
      'Không thể tải các bộ thẻ đã lưu. Hãy khởi động lại ứng dụng trước khi thay đổi.';

  @override
  String supabaseDeckError(String error) {
    return 'Không thể đồng bộ bộ thẻ với Supabase: $error';
  }

  @override
  String supabaseInitError(String error) {
    return 'Không thể kết nối với Supabase: $error';
  }

  @override
  String get needAccount => 'Chưa có tài khoản? Đăng ký';

  @override
  String get haveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get back => 'Quay lại';

  @override
  String get create => 'Tạo';

  @override
  String get createDeck => 'Tạo bộ thẻ';

  @override
  String get importDeckTooltip => 'Nhập bộ thẻ';

  @override
  String get timer => 'Bộ hẹn giờ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get spanish => 'Tiếng Tây Ban Nha';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get chinese => 'Tiếng Trung';

  @override
  String get japanese => 'Tiếng Nhật';

  @override
  String get dutch => 'Tiếng Hà Lan';

  @override
  String get german => 'Tiếng Đức';

  @override
  String hiUser(String username) {
    return 'Xin chào, $username';
  }

  @override
  String deckCount(int count) {
    return '$count bộ thẻ';
  }

  @override
  String flashcardCount(int count) {
    return '$count thẻ ghi nhớ';
  }

  @override
  String minutesStudied(int count) {
    return 'Đã học $count phút';
  }

  @override
  String get searchDecks => 'Tìm bộ thẻ';

  @override
  String get yourLibrary => 'Thư viện của bạn';

  @override
  String get noDecksFound =>
      'Không tìm thấy bộ thẻ. Hãy tạo một bộ để bắt đầu.';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards thẻ • đã học $minutes phút';
  }

  @override
  String get editDeck => 'Sửa bộ thẻ';

  @override
  String get exportDeck => 'Xuất bộ thẻ';

  @override
  String get deckCopied =>
      'Đã sao chép JSON của bộ thẻ. Hãy dán vào tệp hoặc chia sẻ để nhập.';

  @override
  String get flashcards => 'Thẻ ghi nhớ';

  @override
  String get takeQuiz => 'Làm bài trắc nghiệm';

  @override
  String get newDeck => 'Bộ thẻ mới';

  @override
  String get title => 'Tiêu đề';

  @override
  String cardNumber(int number) {
    return 'Thẻ $number';
  }

  @override
  String get removeCard => 'Xóa thẻ';

  @override
  String get term => 'Thuật ngữ';

  @override
  String get definition => 'Định nghĩa';

  @override
  String get addCard => 'Thêm thẻ';

  @override
  String get saveDeck => 'Lưu bộ thẻ';

  @override
  String get requiredText => 'Vui lòng nhập nội dung';

  @override
  String get minimumTwoCards => 'Một bộ cần ít nhất 2 thẻ.';

  @override
  String get importDeck => 'Nhập bộ thẻ';

  @override
  String get pasteDeckJson => 'Dán JSON đã xuất của bộ thẻ';

  @override
  String get cancel => 'Hủy';

  @override
  String get import => 'Nhập';

  @override
  String get invalidDeck =>
      'Bộ thẻ không hợp lệ. Hãy dán bản xuất StudySpace đầy đủ.';

  @override
  String get saveError => 'Không thể lưu thay đổi trên thiết bị này.';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get focusComplete =>
      'Đã hoàn thành phiên tập trung. Hãy nghỉ giải lao!';

  @override
  String get sessionComplete => 'Đã hoàn thành phiên học';

  @override
  String retryMissed(int count) {
    return 'Ôn lại $count thẻ chưa nhớ';
  }

  @override
  String get backToLibrary => 'Quay lại thư viện';

  @override
  String quizProgress(int current, int total) {
    return 'Trắc nghiệm • $current/$total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'Thẻ ghi nhớ • $current/$total';
  }

  @override
  String correctCount(int correct, int total) {
    return 'Đúng $correct/$total câu';
  }

  @override
  String rememberedCount(int correct, int total) {
    return 'Đã nhớ $correct/$total thẻ';
  }

  @override
  String get tapOrSwipe =>
      'Chạm để lật · Vuốt trái: cần học thêm · Vuốt phải: đã nhớ';

  @override
  String get whichTerm => 'Thuật ngữ nào phù hợp với định nghĩa này?';

  @override
  String get correct => 'Chính xác!';

  @override
  String incorrectAnswer(String term) {
    return 'Chưa đúng. Thuật ngữ đúng là $term.';
  }

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get flipCard => 'Lật thẻ';

  @override
  String get stillLearning => 'Chưa thuộc';

  @override
  String get gotIt => 'Đã thuộc';

  @override
  String get makeTimeToStudy => 'Dành thời gian học tập';

  @override
  String get createDeckFirst =>
      'Hãy tạo bộ thẻ trước rồi quay lại để bắt đầu phiên học có hẹn giờ.';

  @override
  String get studyDeck => 'Bộ thẻ học tập';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focusMinutes => '25 phút tập trung';

  @override
  String minutes(int count) {
    return '$count phút';
  }

  @override
  String get timerDuration => 'Thời lượng hẹn giờ';

  @override
  String get studyWithCountdown =>
      'Học thẻ ghi nhớ với đồng hồ đếm ngược ở phía trên.';

  @override
  String get pauseTimer => 'Tạm dừng hẹn giờ';

  @override
  String get startTimer => 'Bắt đầu hẹn giờ';

  @override
  String get resetTimer => 'Đặt lại hẹn giờ';

  @override
  String studyTime(String duration) {
    return 'Thời gian học $duration';
  }

  @override
  String get openEnded => 'Không giới hạn';

  @override
  String get openEndedDescription => 'Đếm tăng và học theo nhịp độ của bạn.';

  @override
  String get flowtime => 'Flowtime / Flowmodoro';

  @override
  String get flowtimeDescription =>
      'Học tự do, rồi nghỉ bằng một phần năm thời gian tập trung.';

  @override
  String get takeBreak => 'Nghỉ giải lao';

  @override
  String get resumeFocus => 'Bắt đầu phiên học tiếp theo';

  @override
  String get breakTimer => 'Giải lao';

  @override
  String get breakComplete => 'Hết giờ nghỉ. Sẵn sàng học tiếp?';
}
