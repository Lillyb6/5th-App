import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'mockup.dart';
import 'app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://regxvjrxgxynwlnqmusu.supabase.co',
);
const supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
  defaultValue: 'sb_publishable_8obXktLdXhvqDnH0r8SREQ_fFaGqV3X',
);
const supabaseConfigured = supabaseUrl != '' && supabasePublishableKey != '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? supabaseStartupError;
  var supabaseEnabled = false;
  if (supabaseUrl.isEmpty != supabasePublishableKey.isEmpty) {
    supabaseStartupError =
        'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY must both be configured.';
  } else if (supabaseConfigured) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabasePublishableKey,
      );
      supabaseEnabled = true;
    } catch (error) {
      supabaseStartupError = error.toString();
    }
  }
  runApp(
    MyApp(
      supabaseEnabled: supabaseEnabled,
      supabaseStartupError: supabaseStartupError,
    ),
  );
}

class Flashcard {
  Flashcard(this.term, this.answer);
  final String term;
  final String answer;
  Map<String, dynamic> toJson() => {'term': term, 'answer': answer};
}

class Deck {
  Deck(this.title, this.cards, {this.seconds = 0, this.completedCards = 0});
  String title;
  List<Flashcard> cards;
  int seconds;
  int completedCards;
  Map<String, dynamic> toJson() => {
    'title': title,
    'cards': cards.map((c) => c.toJson()).toList(),
    'seconds': seconds,
    'completedCards': completedCards,
  };
  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
    json['title'] as String,
    (json['cards'] as List)
        .map((c) => Flashcard(c['term'] as String, c['answer'] as String))
        .toList(),
    seconds: json['seconds'] as int? ?? 0,
    completedCards: json['completedCards'] as int? ?? 0,
  );
}

class LocalAccounts {
  static const demoUsername = 'demo';
  static const demoPassword = 'studyspace123';
  static const _accountsKey = 'studyspace.accounts.v1';

  static String normalizeUsername(String username) =>
      username.trim().toLowerCase();

  static String deckStorageKey(String username) =>
      'studyspace.user-decks.v1.${base64Url.encode(utf8.encode(normalizeUsername(username)))}';

  static Future<bool> authenticate(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = _loadAccounts(prefs);
    final normalized = normalizeUsername(username);
    if (normalized == demoUsername && !accounts.containsKey(demoUsername)) {
      accounts[demoUsername] = _record(
        demoUsername,
        demoPassword,
        'studyspace-demo-salt-v1',
      );
      await _saveAccounts(prefs, accounts);
    }
    final account = accounts[normalized];
    return account != null &&
        account['passwordHash'] ==
            _passwordHash(account['salt'] as String, password);
  }

  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = _loadAccounts(prefs);
    final normalized = normalizeUsername(username);
    if (normalized == demoUsername || accounts.containsKey(normalized)) {
      return false;
    }
    final salt = base64Url.encode(
      List<int>.generate(16, (_) => Random.secure().nextInt(256)),
    );
    accounts[normalized] = _record(normalized, password, salt);
    await _saveAccounts(prefs, accounts);
    return true;
  }

  static Map<String, dynamic> _loadAccounts(SharedPreferences prefs) {
    final saved = prefs.getString(_accountsKey);
    return saved == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(saved) as Map);
  }

  static Map<String, dynamic> _record(
    String username,
    String password,
    String salt,
  ) => {
    'username': username,
    'salt': salt,
    'passwordHash': _passwordHash(salt, password),
  };

  static String _passwordHash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  static Future<void> _saveAccounts(
    SharedPreferences prefs,
    Map<String, dynamic> accounts,
  ) async {
    if (!await prefs.setString(_accountsKey, jsonEncode(accounts))) {
      throw StateError('Could not save local account data.');
    }
  }
}

List<Deck> demoDecks() => [
  Deck('Earth Science', [
    Flashcard(
      'Tectonic plates',
      'Large sections of Earth’s lithosphere that move over the mantle.',
    ),
    Flashcard(
      'Weathering',
      'The breakdown of rock at or near Earth’s surface.',
    ),
    Flashcard(
      'Water cycle',
      'The continuous movement of water through evaporation, condensation, and precipitation.',
    ),
    Flashcard(
      'Sedimentary rock',
      'Rock formed as layers of sediment are compacted and cemented together.',
    ),
  ]),
  Deck('American Classic Literature', [
    Flashcard(
      'The Great Gatsby',
      'F. Scott Fitzgerald’s novel about wealth, longing, and the American Dream.',
    ),
    Flashcard(
      'Moby-Dick',
      'Herman Melville’s novel centered on Captain Ahab’s pursuit of a white whale.',
    ),
    Flashcard(
      'The Scarlet Letter',
      'Nathaniel Hawthorne’s novel about Hester Prynne in Puritan New England.',
    ),
    Flashcard(
      'Adventures of Huckleberry Finn',
      'Mark Twain’s novel following Huck and Jim along the Mississippi River.',
    ),
  ]),
];

List<Deck> _starterDecks() => [
  Deck('Biology essentials', [
    Flashcard(
      'Mitochondria',
      'The organelles that produce most of a cell’s ATP.',
    ),
    Flashcard(
      'Photosynthesis',
      'The process plants use to convert light into chemical energy.',
    ),
    Flashcard(
      'Osmosis',
      'Movement of water across a selectively permeable membrane.',
    ),
  ]),
];

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.supabaseEnabled = false,
    this.supabaseStartupError,
  });
  final bool supabaseEnabled;
  final String? supabaseStartupError;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _languageKey = 'studyspace.language.v1';
  static const _darkModeKey = 'studyspace.dark-mode.v1';
  final navigatorKey = GlobalKey<NavigatorState>();
  Locale selectedLocale = const Locale('en');
  ThemeMode themeMode = ThemeMode.dark;
  bool settingsLoaded = false;
  String? settingsError;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString(_languageKey) ?? 'en';
      const supported = {'en', 'es', 'vi', 'zh', 'ja', 'nl', 'de'};
      setState(() {
        selectedLocale = Locale(supported.contains(language) ? language : 'en');
        themeMode = prefs.getBool(_darkModeKey) ?? true
            ? ThemeMode.dark
            : ThemeMode.light;
        settingsLoaded = true;
      });
    } catch (error) {
      setState(() {
        settingsError = error.toString();
        settingsLoaded = true;
      });
    }
  }

  Future<void> setLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(_languageKey, locale.languageCode)) {
      throw StateError('Could not save language preference.');
    }
    if (mounted) {
      setState(() => selectedLocale = locale);
    }
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setBool(_darkModeKey, enabled)) {
      throw StateError('Could not save theme preference.');
    }
    if (mounted) {
      setState(() => themeMode = enabled ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> openSettings() => showDialog<void>(
    context: navigatorKey.currentContext!,
    builder: (_) => SettingsDialog(
      selectedLocale: selectedLocale,
      darkMode: themeMode == ThemeMode.dark,
      onLanguageChanged: setLanguage,
      onDarkModeChanged: setDarkMode,
    ),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    title: 'StudySpace',
    debugShowCheckedModeBanner: false,
    locale: selectedLocale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: studySpaceTheme(Brightness.light),
    darkTheme: studySpaceTheme(Brightness.dark),
    themeMode: themeMode,
    home: Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        if (!settingsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (settingsError != null) {
          return Scaffold(
            body: Center(child: Text(l10n.settingsLoadError(settingsError!))),
          );
        }
        if (widget.supabaseStartupError != null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.supabaseInitError(widget.supabaseStartupError!),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return EntryPage(
          onSettings: openSettings,
          supabaseEnabled: widget.supabaseEnabled,
        );
      },
    ),
  );
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    required this.selectedLocale,
    required this.darkMode,
    required this.onLanguageChanged,
    required this.onDarkModeChanged,
  });

  final Locale selectedLocale;
  final bool darkMode;
  final Future<void> Function(Locale) onLanguageChanged;
  final Future<void> Function(bool) onDarkModeChanged;

  String languageName(AppLocalizations l10n, String code) => switch (code) {
    'es' => l10n.spanish,
    'vi' => l10n.vietnamese,
    'zh' => l10n.chinese,
    'ja' => l10n.japanese,
    'nl' => l10n.dutch,
    'de' => l10n.german,
    _ => l10n.english,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.settings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Locale>(
            initialValue: selectedLocale,
            decoration: InputDecoration(labelText: l10n.language),
            items: AppLocalizations.supportedLocales
                .map(
                  (locale) => DropdownMenuItem(
                    value: locale,
                    child: Text(languageName(l10n, locale.languageCode)),
                  ),
                )
                .toList(),
            onChanged: (locale) async {
              if (locale == null) {
                return;
              }
              try {
                await onLanguageChanged(locale);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsSaveError(error.toString())),
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.darkMode),
            value: darkMode,
            onChanged: (enabled) async {
              try {
                await onDarkModeChanged(enabled);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsSaveError(error.toString())),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.back),
        ),
      ],
    );
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
    this.username = 'Learner',
    this.storageKey = 'studyspace.decks.v1',
    this.initialDecks,
    this.onSignOut,
    this.onSettings,
    this.remoteUserId,
  });
  final String username;
  final String storageKey;
  final List<Deck>? initialDecks;
  final Future<void> Function()? onSignOut;
  final VoidCallback? onSettings;
  final String? remoteUserId;
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Deck> decks = [];
  bool loading = true;
  String search = '';
  bool showLibrary = false;
  String? storageFailure;
  Future<void> writes = Future.value();
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      if (widget.remoteUserId case final userId?) {
        final record = await Supabase.instance.client
            .from('user_deck_data')
            .select('decks')
            .eq('user_id', userId)
            .maybeSingle();
        final saved = record?['decks'];
        decks = saved is List
            ? saved
                  .map(
                    (deck) =>
                        Deck.fromJson(Map<String, dynamic>.from(deck as Map)),
                  )
                  .toList()
            : widget.initialDecks ?? _starterDecks();
      } else {
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString(widget.storageKey);
        decks = saved == null
            ? widget.initialDecks ?? _starterDecks()
            : (jsonDecode(saved) as List).map((d) => Deck.fromJson(d)).toList();
      }
    } catch (error) {
      storageFailure = error.toString();
    }
    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> save() {
    final snapshot = jsonEncode(decks.map((d) => d.toJson()).toList());
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    writes = writes.then((_) async {
      try {
        if (widget.remoteUserId case final userId?) {
          await Supabase.instance.client.from('user_deck_data').upsert({
            'user_id': userId,
            'decks': jsonDecode(snapshot),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          });
        } else {
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString(widget.storageKey, snapshot)) {
            throw StateError('Save failed');
          }
        }
      } catch (error) {
        if (!mounted) {
          return;
        }
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              widget.remoteUserId == null
                  ? '${l10n.saveError} $error'
                  : l10n.supabaseDeckError(error.toString()),
            ),
          ),
        );
      }
    });
    return writes;
  }

  Future<void> edit([Deck? deck]) async {
    final result = await Navigator.of(context)
        .push<Deck>(MaterialPageRoute(builder: (_) => EditorPage(deck: deck)));
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      if (deck == null) {
        decks.add(result);
      } else {
        decks[decks.indexOf(deck)] = result;
      }
    });
    await save();
  }

  Future<void> study(
    Deck deck,
    bool quiz, {
    int? minutes,
    StudyTimerMode timerMode = StudyTimerMode.pomodoro,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudyPage(
          deck: deck,
          quiz: quiz,
          initialMinutes: minutes ?? 25,
          timerMode: timerMode,
          autoStart: minutes != null,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
      await save();
    }
  }

  Future<void> chooseTimer() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TimerChoicePage(
          decks: decks,
          onStudy: (deck, minutes, mode) =>
              study(deck, false, minutes: minutes, timerMode: mode),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> importDeck() async {
    final l10n = AppLocalizations.of(context)!;
    final input = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importDeck),
        content: TextField(
          controller: input,
          maxLines: 8,
          decoration: InputDecoration(hintText: l10n.pasteDeckJson),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text),
            child: Text(l10n.import),
          ),
        ],
      ),
    );
    // The dialog's route may still be animating; its field owns this controller until removal.
    if (raw == null || !mounted) {
      return;
    }
    try {
      final deck = Deck.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (deck.title.trim().isEmpty ||
          deck.cards.length < 2 ||
          deck.cards.any(
            (c) => c.term.trim().isEmpty || c.answer.trim().isEmpty,
          )) {
        throw const FormatException();
      }
      setState(() => decks.add(deck));
      await save();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.invalidDeck)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !showLibrary,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && showLibrary) setState(() => showLibrary = false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: showLibrary
              ? IconButton(
                  tooltip: l10n.home,
                  onPressed: () => setState(() => showLibrary = false),
                  icon: const Icon(Icons.arrow_back_rounded),
                )
              : const Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.auto_awesome_rounded),
                ),
          title: Text(showLibrary ? l10n.library : 'Study Space'),
          actions: [
            if (widget.onSignOut != null)
              IconButton(
                tooltip: l10n.signOut,
                onPressed: () async {
                  try {
                    await widget.onSignOut!();
                  } catch (error) {
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.authRequestError(error.toString())),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
              ),
            IconButton(
              tooltip: l10n.settings,
              onPressed: widget.onSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
            if (showLibrary)
              IconButton(
                tooltip: l10n.importDeckTooltip,
                onPressed: loading || storageFailure != null
                    ? null
                    : importDeck,
                icon: const Icon(Icons.file_download_outlined),
              ),
            const SizedBox(width: 12),
          ],
        ),
        floatingActionButton: showLibrary && !loading && storageFailure == null
            ? FloatingActionButton.extended(
                tooltip: l10n.createDeck,
                onPressed: () => edit(),
                icon: const Icon(Icons.add),
                label: Text(l10n.createNewDeck),
              )
            : null,
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : storageFailure != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    widget.remoteUserId == null
                        ? l10n.deckLoadError
                        : l10n.supabaseDeckError(storageFailure!),
                  ),
                ),
              )
            : !showLibrary
            ? StudyHome(
                username: widget.username,
                decks: decks,
                onLibrary: () => setState(() => showLibrary = true),
                onStudy: chooseTimer,
                onCreate: () => edit(),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                    children: [
                      Text(
                        l10n.yourLibrary,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.libraryDescription,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        onChanged: (value) => setState(() => search = value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: l10n.searchDecks,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.deckCount(decks.length),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (decks
                          .where(
                            (d) => d.title.toLowerCase().contains(
                              search.toLowerCase(),
                            ),
                          )
                          .isEmpty)
                        Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(l10n.noDecksFound),
                        ),
                      ...decks
                          .where(
                            (d) => d.title.toLowerCase().contains(
                              search.toLowerCase(),
                            ),
                          )
                          .map(
                            (deck) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.style,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            deck.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: l10n.editDeck,
                                          onPressed: () => edit(deck),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          tooltip: l10n.exportDeck,
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text:
                                                    const JsonEncoder.withIndent(
                                                      '  ',
                                                    ).convert(deck.toJson()),
                                              ),
                                            );
                                            if (!context.mounted) {
                                              return;
                                            }
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(l10n.deckCopied),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.ios_share),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      l10n.cardsStudied(
                                        deck.cards.length,
                                        deck.seconds ~/ 60,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        FilledButton.icon(
                                          onPressed: () => study(deck, false),
                                          icon: const Icon(
                                            Icons.auto_stories_outlined,
                                          ),
                                          label: Text(l10n.flashcards),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () => study(deck, true),
                                          icon: const Icon(Icons.quiz_outlined),
                                          label: Text(l10n.takeQuiz),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, this.deck});
  final Deck? deck;
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title;
  late final List<(TextEditingController, TextEditingController)> cards;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.deck?.title);
    cards = (widget.deck?.cards ?? [Flashcard('', ''), Flashcard('', '')])
        .map(
          (c) => (
            TextEditingController(text: c.term),
            TextEditingController(text: c.answer),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    title.dispose();
    for (final c in cards) {
      c.$1.dispose();
      c.$2.dispose();
    }
    super.dispose();
  }

  String? requiredText(BuildContext context, String? text) =>
      text == null || text.trim().isEmpty
      ? AppLocalizations.of(context)!.requiredText
      : null;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck == null ? l10n.newDeck : l10n.editDeck),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: form,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    validator: (value) => requiredText(context, value),
                    decoration: InputDecoration(labelText: l10n.title),
                  ),
                  const SizedBox(height: 20),
                  ...cards.indexed.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(l10n.cardNumber(entry.$1 + 1)),
                                  ),
                                  IconButton(
                                    tooltip: l10n.removeCard,
                                    onPressed: cards.length <= 2
                                        ? null
                                        : () {
                                            setState(
                                              () => cards.removeAt(entry.$1),
                                            );
                                          },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: entry.$2.$1,
                                validator: (value) =>
                                    requiredText(context, value),
                                decoration: InputDecoration(
                                  labelText: l10n.term,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: entry.$2.$2,
                                validator: (value) =>
                                    requiredText(context, value),
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: l10n.definition,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => setState(
                      () => cards.add((
                        TextEditingController(),
                        TextEditingController(),
                      )),
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCard),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('saveDeckButton'),
                    onPressed: () {
                      final deckCards = cards
                          .map(
                            (c) =>
                                Flashcard(c.$1.text.trim(), c.$2.text.trim()),
                          )
                          .toList();
                      if (form.currentState!.validate() &&
                          deckCards.length >= 2) {
                        Navigator.pop(
                          context,
                          Deck(
                            title.text.trim(),
                            deckCards,
                            seconds: widget.deck?.seconds ?? 0,
                            completedCards: widget.deck?.completedCards ?? 0,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.minimumTwoCards)),
                        );
                      }
                    },
                    child: Text(l10n.saveDeck),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum StudyTimerMode { pomodoro, openEnded, flowtime }

class StudyPage extends StatefulWidget {
  const StudyPage({
    super.key,
    required this.deck,
    required this.quiz,
    this.initialMinutes = 25,
    this.timerMode = StudyTimerMode.pomodoro,
    this.autoStart = false,
  });
  final int initialMinutes;
  final StudyTimerMode timerMode;
  final bool autoStart;
  final Deck deck;
  final bool quiz;
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> with WidgetsBindingObserver {
  late List<Flashcard> round;
  List<String> quizOptions = [];
  final List<Flashcard> missed = [];
  final answer = TextEditingController();
  final watch = Stopwatch();
  Timer? timer;
  int index = 0;
  int focusSeconds = 25 * 60;
  bool focusRunning = false;
  bool onBreak = false;
  double dragDistance = 0;
  bool get countsUp => widget.timerMode != StudyTimerMode.pomodoro && !onBreak;
  int get initialSeconds => widget.timerMode == StudyTimerMode.pomodoro
      ? widget.initialMinutes * 60
      : 0;
  bool flipped = false;
  bool complete = false;
  bool? correct;
  bool active = true;
  @override
  void initState() {
    super.initState();
    round = List.of(widget.deck.cards);
    if (widget.quiz) quizOptions = buildQuizOptions();
    focusSeconds = initialSeconds;
    focusRunning = widget.autoStart;
    watch.start();
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !active || complete) {
        return;
      }
      setState(() {
        if (focusRunning && countsUp) {
          focusSeconds++;
        } else if (focusRunning && focusSeconds > 0) {
          focusSeconds--;
          if (focusSeconds == 0) {
            focusRunning = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  onBreak
                      ? AppLocalizations.of(context)!.breakComplete
                      : AppLocalizations.of(context)!.focusComplete,
                ),
              ),
            );
          }
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    active = state == AppLifecycleState.resumed;
    if (active && !complete) {
      watch.start();
    } else {
      watch.stop();
    }
  }

  @override
  void dispose() {
    widget.deck.seconds += watch.elapsed.inSeconds;
    timer?.cancel();
    watch.stop();
    answer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void next(bool known) {
    setState(() {
      if (!widget.quiz) widget.deck.completedCards++;
      if (!known) {
        missed.add(round[index]);
      }
      if (index == round.length - 1) {
        complete = true;
        watch.stop();
        focusRunning = false;
      } else {
        index++;
        if (widget.quiz) quizOptions = buildQuizOptions();
      }
      flipped = false;
      correct = null;
      answer.clear();
    });
  }

  List<String> buildQuizOptions() {
    final currentTerm = round[index].term;
    final distractors =
        round
            .where((card) => card.term != currentTerm)
            .map((card) => card.term)
            .toList()
          ..shuffle(Random());
    final options = <String>[currentTerm];
    final targetCount = round.length < 4 ? round.length : 4;
    options.addAll(distractors.take(targetCount - 1));
    return options..shuffle(Random());
  }

  String duration(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.deck.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StudyTimerBar(
                seconds: focusSeconds,
                countsUp: countsUp,
                label: onBreak
                    ? l10n.breakTimer
                    : switch (widget.timerMode) {
                        StudyTimerMode.pomodoro => l10n.pomodoro,
                        StudyTimerMode.openEnded => l10n.openEnded,
                        StudyTimerMode.flowtime => l10n.flowtime,
                      },
                running: focusRunning,
                enabled: !complete,
                onToggle: () => setState(() => focusRunning = !focusRunning),
                onReset: () => setState(() {
                  focusSeconds = initialSeconds;
                  onBreak = false;
                  focusRunning = false;
                }),
              ),
              if (widget.timerMode == StudyTimerMode.flowtime && !complete)
                TextButton.icon(
                  onPressed: onBreak || focusSeconds > 0
                      ? () => setState(() {
                          if (onBreak) {
                            onBreak = false;
                            focusSeconds = 0;
                          } else {
                            onBreak = true;
                            focusSeconds = (focusSeconds / 5).ceil();
                          }
                          focusRunning = true;
                        })
                      : null,
                  icon: Icon(
                    onBreak ? Icons.play_arrow : Icons.coffee_outlined,
                  ),
                  label: Text(onBreak ? l10n.resumeFocus : l10n.takeBreak),
                ),
              const SizedBox(height: 8),
              Text(
                l10n.studyTime(duration(watch.elapsed.inSeconds)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (complete) ...[
                Icon(
                  Icons.celebration_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sessionComplete,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.quiz
                      ? l10n.correctCount(
                          round.length - missed.length,
                          round.length,
                        )
                      : l10n.rememberedCount(
                          round.length - missed.length,
                          round.length,
                        ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (missed.isNotEmpty)
                  FilledButton(
                    onPressed: () => setState(() {
                      round = List.of(missed);
                      missed.clear();
                      index = 0;
                      if (widget.quiz) quizOptions = buildQuizOptions();
                      complete = false;
                      watch.start();
                    }),
                    child: Text(l10n.retryMissed(missed.length)),
                  ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.backToLibrary),
                ),
              ] else ...[
                Text(
                  widget.quiz
                      ? l10n.quizProgress(index + 1, round.length)
                      : l10n.studyProgress(index + 1, round.length),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: index / round.length),
                const SizedBox(height: 24),
                if (!widget.quiz)
                  GestureDetector(
                    onTap: widget.quiz
                        ? null
                        : () => setState(() => flipped = !flipped),
                    onHorizontalDragStart: widget.quiz
                        ? null
                        : (_) => setState(() => dragDistance = 0),
                    onHorizontalDragUpdate: widget.quiz
                        ? null
                        : (details) =>
                              setState(() => dragDistance += details.delta.dx),
                    onHorizontalDragCancel: widget.quiz
                        ? null
                        : () => setState(() => dragDistance = 0),
                    onHorizontalDragEnd: widget.quiz
                        ? null
                        : (_) {
                            final distance = dragDistance;
                            setState(() => dragDistance = 0);
                            if (distance.abs() >= 80) next(distance > 0);
                          },
                    child: Transform.translate(
                      offset: Offset(dragDistance, 0),
                      child: Semantics(
                        button: !widget.quiz,
                        label: widget.quiz ? l10n.whichTerm : l10n.tapOrSwipe,
                        child: Card(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 240),
                              padding: const EdgeInsets.all(32),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    flipped
                                        ? l10n.definition.toUpperCase()
                                        : l10n.term.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    flipped
                                        ? round[index].answer
                                        : round[index].term,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  if (!widget.quiz) ...[
                                    const SizedBox(height: 24),
                                    Text(l10n.tapOrSwipe),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                if (widget.quiz) ...[
                  Text(
                    l10n.whichTerm,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        round[index].answer,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (correct == null)
                    ...quizOptions.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FilledButton.tonal(
                          onPressed: () => setState(() {
                            correct = option == round[index].term;
                          }),
                          child: Text(option),
                        ),
                      ),
                    )
                  else ...[
                    Text(
                      correct!
                          ? l10n.correct
                          : l10n.incorrectAnswer(round[index].term),
                      style: TextStyle(
                        color: correct!
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => next(correct!),
                      child: Text(l10n.continueButton),
                    ),
                  ],
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: () => setState(() => flipped = !flipped),
                    icon: const Icon(Icons.flip),
                    label: Text(l10n.flipCard),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: flipped ? () => next(false) : null,
                          child: Text(l10n.stillLearning),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: flipped ? () => next(true) : null,
                          child: Text(l10n.gotIt),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
