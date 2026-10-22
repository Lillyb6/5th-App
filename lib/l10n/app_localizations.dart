import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_vi.dart';
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
/// import 'l10n/app_localizations.dart';
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
    Locale('ja'),
    Locale('nl'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Make a little room for learning.'**
  String get tagline;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Try the demo account: demo / studyspace123'**
  String get demoCredentials;

  /// No description provided for @supabaseSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to sync your decks with Supabase.'**
  String get supabaseSignInHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @localOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Accounts and decks are stored only on this device. This prototype does not use server authentication or sync.'**
  String get localOnlyNotice;

  /// No description provided for @supabaseNotice.
  ///
  /// In en, this message translates to:
  /// **'Guest decks stay on this device. Signed-in account decks sync with Supabase.'**
  String get supabaseNotice;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @minimumUsername.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters for your username'**
  String get minimumUsername;

  /// No description provided for @minimumPassword.
  ///
  /// In en, this message translates to:
  /// **'Use a password with at least 8 characters'**
  String get minimumPassword;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @usernameTaken.
  ///
  /// In en, this message translates to:
  /// **'That username is already taken.'**
  String get usernameTaken;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @emailConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account, then sign in.'**
  String get emailConfirmation;

  /// No description provided for @authRequestError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the account request: {error}'**
  String authRequestError(String error);

  /// No description provided for @accountStorageError.
  ///
  /// In en, this message translates to:
  /// **'Could not access local accounts: {error}'**
  String accountStorageError(String error);

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save settings: {error}'**
  String settingsSaveError(String error);

  /// No description provided for @settingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load app settings: {error}'**
  String settingsLoadError(String error);

  /// No description provided for @deckLoadError.
  ///
  /// In en, this message translates to:
  /// **'Saved decks could not be loaded. Restart the app before making changes.'**
  String get deckLoadError;

  /// No description provided for @supabaseDeckError.
  ///
  /// In en, this message translates to:
  /// **'Could not sync decks with Supabase: {error}'**
  String supabaseDeckError(String error);

  /// No description provided for @supabaseInitError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to Supabase: {error}'**
  String supabaseInitError(String error);

  /// No description provided for @needAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign up'**
  String get needAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createDeck.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get createDeck;

  /// No description provided for @importDeckTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import deck'**
  String get importDeckTooltip;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {username}'**
  String hiUser(String username);

  /// No description provided for @deckCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No decks} =1{1 deck} other{{count} decks}}'**
  String deckCount(int count);

  /// No description provided for @flashcardCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No flashcards} =1{1 flashcard} other{{count} flashcards}}'**
  String flashcardCount(int count);

  /// No description provided for @minutesStudied.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes studied'**
  String minutesStudied(int count);

  /// No description provided for @searchDecks.
  ///
  /// In en, this message translates to:
  /// **'Search your decks'**
  String get searchDecks;

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your library'**
  String get yourLibrary;

  /// No description provided for @noDecksFound.
  ///
  /// In en, this message translates to:
  /// **'No decks found. Create a deck to get started.'**
  String get noDecksFound;

  /// No description provided for @cardsStudied.
  ///
  /// In en, this message translates to:
  /// **'{cards} cards • {minutes} minutes studied'**
  String cardsStudied(int cards, int minutes);

  /// No description provided for @editDeck.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get editDeck;

  /// No description provided for @exportDeck.
  ///
  /// In en, this message translates to:
  /// **'Export deck'**
  String get exportDeck;

  /// No description provided for @deckCopied.
  ///
  /// In en, this message translates to:
  /// **'Deck JSON copied. Paste it into a file or share it for import.'**
  String get deckCopied;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take quiz'**
  String get takeQuiz;

  /// No description provided for @newDeck.
  ///
  /// In en, this message translates to:
  /// **'New deck'**
  String get newDeck;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card {number}'**
  String cardNumber(int number);

  /// No description provided for @removeCard.
  ///
  /// In en, this message translates to:
  /// **'Remove card'**
  String get removeCard;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get term;

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get addCard;

  /// No description provided for @saveDeck.
  ///
  /// In en, this message translates to:
  /// **'Save deck'**
  String get saveDeck;

  /// No description provided for @requiredText.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get requiredText;

  /// No description provided for @minimumTwoCards.
  ///
  /// In en, this message translates to:
  /// **'A deck needs at least 2 cards.'**
  String get minimumTwoCards;

  /// No description provided for @importDeck.
  ///
  /// In en, this message translates to:
  /// **'Import a deck'**
  String get importDeck;

  /// No description provided for @pasteDeckJson.
  ///
  /// In en, this message translates to:
  /// **'Paste exported deck JSON'**
  String get pasteDeckJson;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @invalidDeck.
  ///
  /// In en, this message translates to:
  /// **'Invalid deck. Paste a complete StudySpace export.'**
  String get invalidDeck;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save changes on this device.'**
  String get saveError;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @focusComplete.
  ///
  /// In en, this message translates to:
  /// **'Focus session complete. Take a break!'**
  String get focusComplete;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get sessionComplete;

  /// No description provided for @retryMissed.
  ///
  /// In en, this message translates to:
  /// **'Retry {count} missed cards'**
  String retryMissed(int count);

  /// No description provided for @backToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Back to library'**
  String get backToLibrary;

  /// No description provided for @quizProgress.
  ///
  /// In en, this message translates to:
  /// **'Quiz • {current} of {total}'**
  String quizProgress(int current, int total);

  /// No description provided for @studyProgress.
  ///
  /// In en, this message translates to:
  /// **'Flashcards • {current} of {total}'**
  String studyProgress(int current, int total);

  /// No description provided for @correctCount.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} correct'**
  String correctCount(int correct, int total);

  /// No description provided for @rememberedCount.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} remembered'**
  String rememberedCount(int correct, int total);

  /// No description provided for @tapOrSwipe.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip · Swipe left: still learning · Swipe right: got it'**
  String get tapOrSwipe;

  /// No description provided for @whichTerm.
  ///
  /// In en, this message translates to:
  /// **'Which term matches this definition?'**
  String get whichTerm;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @incorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Not quite. The correct term is {term}.'**
  String incorrectAnswer(String term);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @flipCard.
  ///
  /// In en, this message translates to:
  /// **'Flip card'**
  String get flipCard;

  /// No description provided for @stillLearning.
  ///
  /// In en, this message translates to:
  /// **'Still learning'**
  String get stillLearning;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @makeTimeToStudy.
  ///
  /// In en, this message translates to:
  /// **'Make time to study'**
  String get makeTimeToStudy;

  /// No description provided for @createDeckFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a deck first, then come back to start a timed flashcard session.'**
  String get createDeckFirst;

  /// No description provided for @studyDeck.
  ///
  /// In en, this message translates to:
  /// **'Study deck'**
  String get studyDeck;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @focusMinutes.
  ///
  /// In en, this message translates to:
  /// **'25 minutes of focus'**
  String get focusMinutes;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutes(int count);

  /// No description provided for @timerDuration.
  ///
  /// In en, this message translates to:
  /// **'Timer duration'**
  String get timerDuration;

  /// No description provided for @studyWithCountdown.
  ///
  /// In en, this message translates to:
  /// **'Study flashcards with the countdown at the top.'**
  String get studyWithCountdown;

  /// No description provided for @pauseTimer.
  ///
  /// In en, this message translates to:
  /// **'Pause focus timer'**
  String get pauseTimer;

  /// No description provided for @startTimer.
  ///
  /// In en, this message translates to:
  /// **'Start focus timer'**
  String get startTimer;

  /// No description provided for @resetTimer.
  ///
  /// In en, this message translates to:
  /// **'Reset timer'**
  String get resetTimer;

  /// No description provided for @studyTime.
  ///
  /// In en, this message translates to:
  /// **'Study time {duration}'**
  String studyTime(String duration);

  /// No description provided for @openEnded.
  ///
  /// In en, this message translates to:
  /// **'Open-ended'**
  String get openEnded;

  /// No description provided for @openEndedDescription.
  ///
  /// In en, this message translates to:
  /// **'Count up and study at your own pace.'**
  String get openEndedDescription;

  /// No description provided for @flowtime.
  ///
  /// In en, this message translates to:
  /// **'Flowtime / Flowmodoro'**
  String get flowtime;

  /// No description provided for @flowtimeDescription.
  ///
  /// In en, this message translates to:
  /// **'Focus freely, then take a break for one-fifth of your focus time.'**
  String get flowtimeDescription;

  /// No description provided for @takeBreak.
  ///
  /// In en, this message translates to:
  /// **'Take a break'**
  String get takeBreak;

  /// No description provided for @resumeFocus.
  ///
  /// In en, this message translates to:
  /// **'Start next focus session'**
  String get resumeFocus;

  /// No description provided for @breakTimer.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get breakTimer;

  /// No description provided for @breakComplete.
  ///
  /// In en, this message translates to:
  /// **'Break complete. Ready to focus again?'**
  String get breakComplete;
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
    'ja',
    'nl',
    'vi',
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
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'vi':
      return AppLocalizationsVi();
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
