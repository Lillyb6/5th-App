// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tagline => 'Schaffe ein wenig Platz zum Lernen.';

  @override
  String get demoCredentials => 'Demo-Konto ausprobieren: demo / studyspace123';

  @override
  String get supabaseSignInHint =>
      'Melde dich an oder erstelle ein Konto, um deine Kartensätze mit Supabase zu synchronisieren.';

  @override
  String get signIn => 'Anmelden';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get localOnlyNotice =>
      'Konten und Kartensätze werden nur auf diesem Gerät gespeichert. Diese Vorschau verwendet keine Serveranmeldung oder Synchronisierung.';

  @override
  String get supabaseNotice =>
      'Gast-Kartensätze bleiben auf diesem Gerät. Kartensätze angemeldeter Konten werden mit Supabase synchronisiert.';

  @override
  String get username => 'Benutzername';

  @override
  String get email => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get minimumUsername =>
      'Der Benutzername muss mindestens 3 Zeichen lang sein';

  @override
  String get minimumPassword =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get passwordsMismatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get usernameTaken => 'Dieser Benutzername ist bereits vergeben.';

  @override
  String get invalidCredentials => 'Benutzername oder Passwort ist falsch.';

  @override
  String get emailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get emailConfirmation =>
      'Prüfe deine E-Mail, um dein Konto zu bestätigen, und melde dich dann an.';

  @override
  String authRequestError(String error) {
    return 'Die Kontoanfrage konnte nicht abgeschlossen werden: $error';
  }

  @override
  String accountStorageError(String error) {
    return 'Auf lokale Konten konnte nicht zugegriffen werden: $error';
  }

  @override
  String settingsSaveError(String error) {
    return 'Einstellungen konnten nicht gespeichert werden: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'App-Einstellungen konnten nicht geladen werden: $error';
  }

  @override
  String get deckLoadError =>
      'Gespeicherte Kartensätze konnten nicht geladen werden. Starte die App neu, bevor du Änderungen vornimmst.';

  @override
  String supabaseDeckError(String error) {
    return 'Kartensätze konnten nicht mit Supabase synchronisiert werden: $error';
  }

  @override
  String supabaseInitError(String error) {
    return 'Verbindung zu Supabase fehlgeschlagen: $error';
  }

  @override
  String get needAccount => 'Noch kein Konto? Registrieren';

  @override
  String get haveAccount => 'Schon ein Konto? Anmelden';

  @override
  String get back => 'Zurück';

  @override
  String get create => 'Erstellen';

  @override
  String get createDeck => 'Kartensatz erstellen';

  @override
  String get importDeckTooltip => 'Kartensatz importieren';

  @override
  String get timer => 'Timer';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get vietnamese => 'Vietnamesisch';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get japanese => 'Japanisch';

  @override
  String get dutch => 'Niederländisch';

  @override
  String get german => 'Deutsch';

  @override
  String hiUser(String username) {
    return 'Hallo, $username';
  }

  @override
  String deckCount(int count) {
    return '$count Kartensätze';
  }

  @override
  String flashcardCount(int count) {
    return '$count Lernkarten';
  }

  @override
  String minutesStudied(int count) {
    return '$count Minuten gelernt';
  }

  @override
  String get searchDecks => 'Kartensätze durchsuchen';

  @override
  String get yourLibrary => 'Deine Bibliothek';

  @override
  String get noDecksFound =>
      'Keine Kartensätze gefunden. Erstelle einen Satz, um loszulegen.';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards Karten • $minutes Minuten gelernt';
  }

  @override
  String get editDeck => 'Kartensatz bearbeiten';

  @override
  String get exportDeck => 'Kartensatz exportieren';

  @override
  String get deckCopied =>
      'Das JSON des Kartensatzes wurde kopiert. Füge es in eine Datei ein oder teile es zum Importieren.';

  @override
  String get flashcards => 'Lernkarten';

  @override
  String get takeQuiz => 'Quiz starten';

  @override
  String get newDeck => 'Neuer Kartensatz';

  @override
  String get title => 'Titel';

  @override
  String cardNumber(int number) {
    return 'Karte $number';
  }

  @override
  String get removeCard => 'Karte entfernen';

  @override
  String get term => 'Begriff';

  @override
  String get definition => 'Definition';

  @override
  String get addCard => 'Karte hinzufügen';

  @override
  String get saveDeck => 'Kartensatz speichern';

  @override
  String get requiredText => 'Bitte Text eingeben';

  @override
  String get minimumTwoCards => 'Ein Kartensatz benötigt mindestens 2 Karten.';

  @override
  String get importDeck => 'Kartensatz importieren';

  @override
  String get pasteDeckJson => 'Exportiertes Kartensatz-JSON einfügen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get import => 'Importieren';

  @override
  String get invalidDeck =>
      'Ungültiger Kartensatz. Füge einen vollständigen StudySpace-Export ein.';

  @override
  String get saveError =>
      'Änderungen konnten nicht auf diesem Gerät gespeichert werden.';

  @override
  String get signOut => 'Abmelden';

  @override
  String get focusComplete => 'Fokussitzung beendet. Mach eine Pause!';

  @override
  String get sessionComplete => 'Sitzung abgeschlossen';

  @override
  String retryMissed(int count) {
    return '$count falsche Karten wiederholen';
  }

  @override
  String get backToLibrary => 'Zurück zur Bibliothek';

  @override
  String quizProgress(int current, int total) {
    return 'Quiz • $current von $total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'Lernkarten • $current von $total';
  }

  @override
  String correctCount(int correct, int total) {
    return '$correct von $total richtig';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '$correct von $total gemerkt';
  }

  @override
  String get tapOrSwipe => 'Tippen oder wischen, um die Karte umzudrehen';

  @override
  String get whichTerm => 'Welcher Begriff passt zu dieser Definition?';

  @override
  String get correct => 'Richtig!';

  @override
  String incorrectAnswer(String term) {
    return 'Nicht ganz. Der richtige Begriff ist $term.';
  }

  @override
  String get continueButton => 'Weiter';

  @override
  String get flipCard => 'Karte umdrehen';

  @override
  String get stillLearning => 'Noch nicht gelernt';

  @override
  String get gotIt => 'Gewusst';

  @override
  String get makeTimeToStudy => 'Zeit zum Lernen finden';

  @override
  String get createDeckFirst =>
      'Erstelle zuerst einen Kartensatz und starte danach eine Lernsitzung mit Timer.';

  @override
  String get studyDeck => 'Kartensatz lernen';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focusMinutes => '25 Minuten konzentrieren';

  @override
  String minutes(int count) {
    return '$count Minuten';
  }

  @override
  String get timerDuration => 'Timerdauer';

  @override
  String get studyWithCountdown =>
      'Lerne mit dem Countdown oben auf dem Bildschirm.';

  @override
  String get pauseTimer => 'Fokustimer pausieren';

  @override
  String get startTimer => 'Fokustimer starten';

  @override
  String get resetTimer => 'Timer zurücksetzen';

  @override
  String studyTime(String duration) {
    return 'Lernzeit $duration';
  }
}
