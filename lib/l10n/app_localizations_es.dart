// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tagline => 'Haz un poco de espacio para aprender.';

  @override
  String get demoCredentials => 'Prueba la cuenta demo: demo / studyspace123';

  @override
  String get supabaseSignInHint =>
      'Inicia sesión o crea una cuenta para sincronizar tus mazos con Supabase.';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get localOnlyNotice =>
      'Las cuentas y los mazos solo se guardan en este dispositivo. Esta versión no usa autenticación ni sincronización con un servidor.';

  @override
  String get supabaseNotice =>
      'Los mazos de invitado se guardan en este dispositivo. Los mazos de las cuentas iniciadas se sincronizan con Supabase.';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get minimumUsername =>
      'El nombre de usuario debe tener al menos 3 caracteres';

  @override
  String get minimumPassword =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get usernameTaken => 'Ese nombre de usuario ya está en uso.';

  @override
  String get invalidCredentials =>
      'El nombre de usuario o la contraseña no son correctos.';

  @override
  String get emailInvalid => 'Introduce una dirección de correo válida';

  @override
  String get resendConfirmationEmail => 'Reenviar correo de confirmación';

  @override
  String get confirmationEmailSent =>
      'Se solicitó un correo de confirmación. Revisa tu bandeja de entrada y la carpeta de spam, y luego inicia sesión.';

  @override
  String get emailConfirmation =>
      'Revisa tu correo para confirmar la cuenta y luego inicia sesión.';

  @override
  String authRequestError(String error) {
    return 'No se pudo completar la solicitud de cuenta: $error';
  }

  @override
  String accountStorageError(String error) {
    return 'No se pudo acceder a las cuentas locales: $error';
  }

  @override
  String settingsSaveError(String error) {
    return 'No se pudo guardar la configuración: $error';
  }

  @override
  String settingsLoadError(String error) {
    return 'No se pudo cargar la configuración: $error';
  }

  @override
  String get deckLoadError =>
      'No se pudieron cargar los mazos guardados. Reinicia la aplicación antes de hacer cambios.';

  @override
  String supabaseDeckError(String error) {
    return 'No se pudieron sincronizar los mazos con Supabase: $error';
  }

  @override
  String supabaseInitError(String error) {
    return 'No se pudo conectar con Supabase: $error';
  }

  @override
  String get needAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get haveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get back => 'Volver';

  @override
  String get create => 'Crear';

  @override
  String get createDeck => 'Crear mazo';

  @override
  String get importDeckTooltip => 'Importar mazo';

  @override
  String get timer => 'Temporizador';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get chinese => 'Chino';

  @override
  String get japanese => 'Japonés';

  @override
  String get dutch => 'Neerlandés';

  @override
  String get german => 'Alemán';

  @override
  String hiUser(String username) {
    return 'Hola, $username';
  }

  @override
  String deckCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mazos',
      one: '1 mazo',
      zero: 'Ningún mazo',
    );
    return '$_temp0';
  }

  @override
  String flashcardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas',
      one: '1 tarjeta',
      zero: 'Ninguna tarjeta',
    );
    return '$_temp0';
  }

  @override
  String minutesStudied(int count) {
    return '$count minutos de estudio';
  }

  @override
  String get searchDecks => 'Buscar tus mazos';

  @override
  String get yourLibrary => 'Tu biblioteca';

  @override
  String get noDecksFound => 'No se encontraron mazos. Crea uno para empezar.';

  @override
  String cardsStudied(int cards, int minutes) {
    return '$cards tarjetas • $minutes minutos de estudio';
  }

  @override
  String get editDeck => 'Editar mazo';

  @override
  String get exportDeck => 'Exportar mazo';

  @override
  String get deckCopied =>
      'Se copió el JSON del mazo. Pégalo en un archivo o compártelo para importarlo.';

  @override
  String get flashcards => 'Tarjetas';

  @override
  String get takeQuiz => 'Hacer cuestionario';

  @override
  String get newDeck => 'Nuevo mazo';

  @override
  String get title => 'Título';

  @override
  String cardNumber(int number) {
    return 'Tarjeta $number';
  }

  @override
  String get removeCard => 'Eliminar tarjeta';

  @override
  String get term => 'Término';

  @override
  String get definition => 'Definición';

  @override
  String get addCard => 'Añadir tarjeta';

  @override
  String get saveDeck => 'Guardar mazo';

  @override
  String get requiredText => 'Introduce un texto';

  @override
  String get minimumTwoCards => 'Un mazo necesita al menos 2 tarjetas.';

  @override
  String get importDeck => 'Importar un mazo';

  @override
  String get pasteDeckJson => 'Pega el JSON exportado del mazo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get import => 'Importar';

  @override
  String get invalidDeck =>
      'Mazo no válido. Pega una exportación completa de StudySpace.';

  @override
  String get saveError =>
      'No se pudieron guardar los cambios en este dispositivo.';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get focusComplete =>
      '¡Sesión de concentración terminada. Tómate un descanso!';

  @override
  String get sessionComplete => 'Sesión completada';

  @override
  String retryMissed(int count) {
    return 'Reintentar $count tarjetas falladas';
  }

  @override
  String get backToLibrary => 'Volver a la biblioteca';

  @override
  String quizProgress(int current, int total) {
    return 'Cuestionario • $current de $total';
  }

  @override
  String studyProgress(int current, int total) {
    return 'Tarjetas • $current de $total';
  }

  @override
  String correctCount(int correct, int total) {
    return '$correct de $total correctas';
  }

  @override
  String rememberedCount(int correct, int total) {
    return '$correct de $total recordadas';
  }

  @override
  String get tapOrSwipe =>
      'Toca para voltear · Izquierda: seguir aprendiendo · Derecha: lo sé';

  @override
  String get whichTerm => '¿Qué término corresponde a esta definición?';

  @override
  String get correct => '¡Correcto!';

  @override
  String incorrectAnswer(String term) {
    return 'No exactamente. El término correcto es $term.';
  }

  @override
  String get continueButton => 'Continuar';

  @override
  String get flipCard => 'Voltear tarjeta';

  @override
  String get stillLearning => 'Aún aprendiendo';

  @override
  String get gotIt => 'Lo sé';

  @override
  String get makeTimeToStudy => 'Haz tiempo para estudiar';

  @override
  String get createDeckFirst =>
      'Crea un mazo primero y vuelve para iniciar una sesión con temporizador.';

  @override
  String get studyDeck => 'Mazo de estudio';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focusMinutes => '25 minutos de concentración';

  @override
  String minutes(int count) {
    return '$count minutos';
  }

  @override
  String get timerDuration => 'Duración del temporizador';

  @override
  String get studyWithCountdown =>
      'Estudia con la cuenta regresiva en la parte superior.';

  @override
  String get pauseTimer => 'Pausar temporizador';

  @override
  String get startTimer => 'Iniciar temporizador';

  @override
  String get resetTimer => 'Reiniciar temporizador';

  @override
  String studyTime(String duration) {
    return 'Tiempo de estudio $duration';
  }

  @override
  String get openEnded => 'Sin límite';

  @override
  String get openEndedDescription =>
      'El tiempo avanza mientras estudias a tu ritmo.';

  @override
  String get flowtime => 'Flowtime / Flowmodoro';

  @override
  String get flowtimeDescription =>
      'Estudia libremente; descansa una quinta parte del tiempo de estudio.';

  @override
  String get takeBreak => 'Tomar un descanso';

  @override
  String get resumeFocus => 'Iniciar la siguiente sesión';

  @override
  String get breakTimer => 'Descanso';

  @override
  String get breakComplete => 'Descanso terminado. ¿Listo para continuar?';

  @override
  String get home => 'Inicio';

  @override
  String get library => 'Biblioteca';

  @override
  String get yourLearningCorner => 'TU RINCÓN PARA APRENDER';

  @override
  String get homeDescription =>
      'Un rincón acogedor para mentes curiosas. Unas tarjetas y un poco de concentración para brillar.';

  @override
  String get decksCreated => 'Mazos creados';

  @override
  String get statMinutesStudied => 'Minutos de estudio';

  @override
  String get flashcardsCompleted => 'Tarjetas completadas';

  @override
  String get makeALittleProgress => 'Avanza un poquito hoy';

  @override
  String get beginStudyingHome => '¡A estudiar!';

  @override
  String get chooseYourRhythm => 'Elige un mazo. Encuentra tu ritmo.';

  @override
  String get createNewDeck => 'Crear nuevo mazo';

  @override
  String get libraryShortcut => 'Todo tu conocimiento en un lugar.';

  @override
  String get createShortcut => 'Dale un hogar a tu próxima gran idea.';

  @override
  String get smallSteps => 'Pequeños pasos. Grandes descubrimientos.';

  @override
  String get libraryDescription => 'Tu colección de pequeños descubrimientos.';

  @override
  String get studySession => 'Sesión de estudio';

  @override
  String get findYourFlow => 'Encuentra tu ritmo.';

  @override
  String get timerIntro =>
      'Un poco de concentración ayuda mucho. Elige tu ritmo.';

  @override
  String get chooseTimer => 'Elige tu temporizador';

  @override
  String get flowtimeShort => 'Flowtime';

  @override
  String get pomodoroDescription =>
      'Una sesión a la vez. Ajusta la cuenta atrás y ponte cómodo.';

  @override
  String get focusSession => 'SESIÓN DE CONCENTRACIÓN';

  @override
  String get beginStudying => 'Comenzar a estudiar';
}
