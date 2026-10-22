// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tagline => 'Make a little room for learning.';

  @override
  String get demoCredentials => 'Try the demo account: demo / studyspace123';

  @override
  String get supabaseSignInHint =>
      'Sign in or create an account to sync your decks with Supabase.';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get localOnlyNotice =>
      'Accounts and decks are stored only on this device. This prototype does not use server authentication or sync.';

  @override
  String get supabaseNotice =>
      'Guest decks stay on this device. Signed-in account decks sync with Supabase.';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get minimumUsername => 'Use at least 3 characters for your username';

  @override
  String get minimumPassword => 'Use a password with at least 8 characters';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get usernameTaken => 'That username is already taken.';

  @override
  String get invalidCredentials => 'Username or password is incorrect.';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get emailConfirmation =>
      'Check your email to confirm your account, then sign in.';

  @override
  String authRequestError(String error) {
    return 'Could not complete the account request: $error';
  }

  @override
  String accountStorageError(String error) {
    return 'Could not access local accounts: $error';
  }

  @override
  String settingsSaveError(String error) {
    return 'Could not save settings: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'Could not load app settings: $error';
  }

  @override
  String get deckLoadError =>
      'Saved decks could not be loaded. Restart the app before making changes.';

  @override
  String supabaseDeckError(String error) {
    return 'Could not sync decks with Supabase: $error';
  }

  @override
  String supabaseInitError(String error) {
    return 'Could not connect to Supabase: $error';
  }

  @override
  String get needAccount => 'Need an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get back => 'Back';

  @override
  String get create => 'Create';

  @override
  String get createDeck => 'Create deck';

  @override
  String get importDeckTooltip => 'Import deck';

  @override
  String get timer => 'Timer';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get dutch => 'Dutch';

  @override
  String get german => 'German';

  @override
  String hiUser(String username) {
    return 'Hi, $username';
  }

  @override
  String deckCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count decks',
      one: '1 deck',
      zero: 'No decks',
    );
    return '$_temp0';
  }

  @override
  String flashcardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count flashcards',
      one: '1 flashcard',
      zero: 'No flashcards',
    );
    return '$_temp0';
  }

  @override
  String minutesStudied(int count) {
    return '$count minutes studied';
  }

  @override
  String get searchDecks => 'Search your decks';

  @override
  String get yourLibrary => 'Your library';

  @override
  String get noDecksFound => 'No decks found. Create a deck to get started.';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards cards • $minutes minutes studied';
  }

  @override
  String get editDeck => 'Edit deck';

  @override
  String get exportDeck => 'Export deck';

  @override
  String get deckCopied =>
      'Deck JSON copied. Paste it into a file or share it for import.';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get takeQuiz => 'Take quiz';

  @override
  String get newDeck => 'New deck';

  @override
  String get title => 'Title';

  @override
  String cardNumber(int number) {
    return 'Card $number';
  }

  @override
  String get removeCard => 'Remove card';

  @override
  String get term => 'Term';

  @override
  String get definition => 'Definition';

  @override
  String get addCard => 'Add card';

  @override
  String get saveDeck => 'Save deck';

  @override
  String get requiredText => 'Please enter some text';

  @override
  String get minimumTwoCards => 'A deck needs at least 2 cards.';

  @override
  String get importDeck => 'Import a deck';

  @override
  String get pasteDeckJson => 'Paste exported deck JSON';

  @override
  String get cancel => 'Cancel';

  @override
  String get import => 'Import';

  @override
  String get invalidDeck => 'Invalid deck. Paste a complete StudySpace export.';

  @override
  String get saveError => 'Could not save changes on this device.';

  @override
  String get signOut => 'Sign out';

  @override
  String get focusComplete => 'Focus session complete. Take a break!';

  @override
  String get sessionComplete => 'Session complete';

  @override
  String retryMissed(int count) {
    return 'Retry $count missed cards';
  }

  @override
  String get backToLibrary => 'Back to library';

  @override
  String quizProgress(int current, int total) {
    return 'Quiz • $current of $total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'Flashcards • $current of $total';
  }

  @override
  String correctCount(int correct, int total) {
    return '$correct of $total correct';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '$correct of $total remembered';
  }

  @override
  String get tapOrSwipe =>
      'Tap to flip · Swipe left: still learning · Swipe right: got it';

  @override
  String get whichTerm => 'Which term matches this definition?';

  @override
  String get correct => 'Correct!';

  @override
  String incorrectAnswer(String term) {
    return 'Not quite. The correct term is $term.';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get flipCard => 'Flip card';

  @override
  String get stillLearning => 'Still learning';

  @override
  String get gotIt => 'Got it';

  @override
  String get makeTimeToStudy => 'Make time to study';

  @override
  String get createDeckFirst =>
      'Create a deck first, then come back to start a timed flashcard session.';

  @override
  String get studyDeck => 'Study deck';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focusMinutes => '25 minutes of focus';

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String get timerDuration => 'Timer duration';

  @override
  String get studyWithCountdown =>
      'Study flashcards with the countdown at the top.';

  @override
  String get pauseTimer => 'Pause focus timer';

  @override
  String get startTimer => 'Start focus timer';

  @override
  String get resetTimer => 'Reset timer';

  @override
  String studyTime(String duration) {
    return 'Study time $duration';
  }

  @override
  String get openEnded => 'Open-ended';

  @override
  String get openEndedDescription => 'Count up and study at your own pace.';

  @override
  String get flowtime => 'Flowtime / Flowmodoro';

  @override
  String get flowtimeDescription =>
      'Focus freely, then take a break for one-fifth of your focus time.';

  @override
  String get takeBreak => 'Take a break';

  @override
  String get resumeFocus => 'Start next focus session';

  @override
  String get breakTimer => 'Break';

  @override
  String get breakComplete => 'Break complete. Ready to focus again?';
}
