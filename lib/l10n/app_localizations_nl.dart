// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get tagline => 'Maak wat ruimte om te leren.';

  @override
  String get demoCredentials =>
      'Probeer het demo-account: demo / studyspace123';

  @override
  String get signIn => 'Inloggen';

  @override
  String get createAccount => 'Account maken';

  @override
  String get continueAsGuest => 'Doorgaan als gast';

  @override
  String get localOnlyNotice =>
      'Accounts en kaartensets worden alleen op dit apparaat opgeslagen. Deze proefversie gebruikt geen serveraanmelding of synchronisatie.';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get confirmPassword => 'Wachtwoord bevestigen';

  @override
  String get minimumUsername =>
      'Je gebruikersnaam moet minstens 3 tekens bevatten';

  @override
  String get minimumPassword => 'Je wachtwoord moet minstens 8 tekens bevatten';

  @override
  String get passwordsMismatch => 'De wachtwoorden komen niet overeen';

  @override
  String get usernameTaken => 'Deze gebruikersnaam is al in gebruik.';

  @override
  String get invalidCredentials => 'Gebruikersnaam of wachtwoord is onjuist.';

  @override
  String accountStorageError(String error) {
    return 'Lokale accounts zijn niet toegankelijk: $error';
  }

  @override
  String settingsSaveError(String error) {
    return 'Instellingen konden niet worden opgeslagen: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'App-instellingen konden niet worden geladen: $error';
  }

  @override
  String get deckLoadError =>
      'Opgeslagen kaartensets konden niet worden geladen. Start de app opnieuw voordat je wijzigingen aanbrengt.';

  @override
  String get needAccount => 'Nog geen account? Aanmelden';

  @override
  String get haveAccount => 'Al een account? Inloggen';

  @override
  String get back => 'Terug';

  @override
  String get create => 'Maken';

  @override
  String get createDeck => 'Kaartenset maken';

  @override
  String get importDeckTooltip => 'Kaartenset importeren';

  @override
  String get timer => 'Timer';

  @override
  String get settings => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get english => 'Engels';

  @override
  String get spanish => 'Spaans';

  @override
  String get vietnamese => 'Vietnamees';

  @override
  String get chinese => 'Chinees';

  @override
  String get japanese => 'Japans';

  @override
  String get dutch => 'Nederlands';

  @override
  String get german => 'Duits';

  @override
  String hiUser(String username) {
    return 'Hallo, $username';
  }

  @override
  String deckCount(int count) {
    return '$count kaartensets';
  }

  @override
  String flashcardCount(int count) {
    return '$count flashcards';
  }

  @override
  String minutesStudied(int count) {
    return '$count minuten gestudeerd';
  }

  @override
  String get searchDecks => 'Kaartensets zoeken';

  @override
  String get yourLibrary => 'Je bibliotheek';

  @override
  String get noDecksFound =>
      'Geen kaartensets gevonden. Maak een set om te beginnen.';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards kaarten • $minutes minuten gestudeerd';
  }

  @override
  String get editDeck => 'Kaartenset bewerken';

  @override
  String get exportDeck => 'Kaartenset exporteren';

  @override
  String get deckCopied =>
      'De JSON van de kaartenset is gekopieerd. Plak deze in een bestand of deel deze om te importeren.';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get takeQuiz => 'Quiz maken';

  @override
  String get newDeck => 'Nieuwe kaartenset';

  @override
  String get title => 'Titel';

  @override
  String cardNumber(int number) {
    return 'Kaart $number';
  }

  @override
  String get removeCard => 'Kaart verwijderen';

  @override
  String get term => 'Term';

  @override
  String get definition => 'Definitie';

  @override
  String get addCard => 'Kaart toevoegen';

  @override
  String get saveDeck => 'Kaartenset opslaan';

  @override
  String get requiredText => 'Voer tekst in';

  @override
  String get minimumTwoCards =>
      'Een kaartenset heeft minstens 2 kaarten nodig.';

  @override
  String get importDeck => 'Kaartenset importeren';

  @override
  String get pasteDeckJson => 'Plak de geëxporteerde JSON van de kaartenset';

  @override
  String get cancel => 'Annuleren';

  @override
  String get import => 'Importeren';

  @override
  String get invalidDeck =>
      'Ongeldige kaartenset. Plak een volledige StudySpace-export.';

  @override
  String get saveError =>
      'Wijzigingen konden niet op dit apparaat worden opgeslagen.';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get focusComplete => 'Focussessie voltooid. Neem even pauze!';

  @override
  String get sessionComplete => 'Sessie voltooid';

  @override
  String retryMissed(int count) {
    return '$count gemiste kaarten opnieuw proberen';
  }

  @override
  String get backToLibrary => 'Terug naar bibliotheek';

  @override
  String quizProgress(int current, int total) {
    return 'Quiz • $current van $total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'Flashcards • $current van $total';
  }

  @override
  String correctCount(int correct, int total) {
    return '$correct van $total goed';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '$correct van $total onthouden';
  }

  @override
  String get tapOrSwipe => 'Tik of veeg om de kaart om te draaien';

  @override
  String get whichTerm => 'Welke term past bij deze definitie?';

  @override
  String get correct => 'Goed!';

  @override
  String incorrectAnswer(String term) {
    return 'Niet helemaal. De juiste term is $term.';
  }

  @override
  String get continueButton => 'Doorgaan';

  @override
  String get flipCard => 'Kaart omdraaien';

  @override
  String get stillLearning => 'Nog aan het leren';

  @override
  String get gotIt => 'Weet ik';

  @override
  String get makeTimeToStudy => 'Maak tijd om te studeren';

  @override
  String get createDeckFirst =>
      'Maak eerst een kaartenset en kom daarna terug voor een studiesessie met timer.';

  @override
  String get studyDeck => 'Kaartenset studeren';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focusMinutes => '25 minuten focussen';

  @override
  String minutes(int count) {
    return '$count minuten';
  }

  @override
  String get timerDuration => 'Timerduur';

  @override
  String get studyWithCountdown => 'Studeer met de aftelling bovenaan.';

  @override
  String get pauseTimer => 'Focustimer pauzeren';

  @override
  String get startTimer => 'Focustimer starten';

  @override
  String get resetTimer => 'Timer opnieuw instellen';

  @override
  String studyTime(String duration) {
    return 'Studietijd $duration';
  }
}
