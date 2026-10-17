import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'main.dart';

const ink = Color(0xff4338ca);

enum _EntryMode { welcome, signIn, signUp }

class EntryPage extends StatefulWidget {
  const EntryPage({super.key, required this.onSettings});
  final VoidCallback onSettings;
  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final user = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final form = GlobalKey<FormState>();
  _EntryMode mode = _EntryMode.welcome;

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void openLibrary({
    required String username,
    required String storageKey,
    List<Deck>? initialDecks,
  }) {
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => LibraryPage(
          username: username,
          storageKey: storageKey,
          initialDecks: initialDecks,
          onSettings: widget.onSettings,
          onSignOut: () => navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => EntryPage(onSettings: widget.onSettings),
            ),
            (_) => false,
          ),
        ),
      ),
    );
  }

  void enterAsGuest() =>
      openLibrary(username: 'Guest', storageKey: 'studyspace.decks.v1');

  Future<void> submitAccount() async {
    final l10n = AppLocalizations.of(context)!;
    if (!form.currentState!.validate()) {
      return;
    }
    final username = user.text.trim();
    try {
      if (mode == _EntryMode.signUp) {
        final created = await LocalAccounts.register(username, password.text);
        if (!created) {
          showMessage(l10n.usernameTaken);
          return;
        }
        openLibrary(
          username: username,
          storageKey: LocalAccounts.deckStorageKey(username),
        );
      } else if (await LocalAccounts.authenticate(username, password.text)) {
        openLibrary(
          username: username,
          storageKey: LocalAccounts.deckStorageKey(username),
          initialDecks:
              LocalAccounts.normalizeUsername(username) ==
                  LocalAccounts.demoUsername
              ? demoDecks()
              : null,
        );
      } else {
        showMessage(l10n.invalidCredentials);
      }
    } catch (error) {
      showMessage(l10n.accountStorageError(error.toString()));
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.settings,
            onPressed: widget.onSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 144,
                    height: 144,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 108,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'StudySpace',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.tagline),
                  const SizedBox(height: 32),
                  if (mode == _EntryMode.welcome) ...[
                    Text(l10n.demoCredentials, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            setState(() => mode = _EntryMode.signIn),
                        child: Text(l10n.signIn),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => mode = _EntryMode.signUp),
                        child: Text(l10n.createAccount),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: enterAsGuest,
                      child: Text(l10n.continueAsGuest),
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.localOnlyNotice, textAlign: TextAlign.center),
                  ] else ...[
                    Form(
                      key: form,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: user,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value == null || value.trim().length < 3
                                ? l10n.minimumUsername
                                : null,
                            decoration: InputDecoration(
                              labelText: l10n.username,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            textInputAction: mode == _EntryMode.signUp
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (mode == _EntryMode.signIn) {
                                submitAccount();
                              }
                            },
                            validator: (value) =>
                                value == null || value.length < 8
                                ? l10n.minimumPassword
                                : null,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),
                          if (mode == _EntryMode.signUp) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: confirmPassword,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => submitAccount(),
                              validator: (value) => value != password.text
                                  ? l10n.passwordsMismatch
                                  : null,
                              decoration: InputDecoration(
                                labelText: l10n.confirmPassword,
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: submitAccount,
                              child: Text(
                                mode == _EntryMode.signUp
                                    ? l10n.createAccount
                                    : l10n.signIn,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(
                              () => mode = mode == _EntryMode.signUp
                                  ? _EntryMode.signIn
                                  : _EntryMode.signUp,
                            ),
                            child: Text(
                              mode == _EntryMode.signUp
                                  ? l10n.haveAccount
                                  : l10n.needAccount,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => mode = _EntryMode.welcome),
                            child: Text(l10n.back),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeActions extends StatelessWidget {
  const HomeActions({super.key, required this.onCreate, required this.onTimer});
  final VoidCallback? onCreate;
  final VoidCallback? onTimer;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(l10n.create, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          width: 88,
          height: 88,
          child: IconButton.filled(
            tooltip: l10n.createDeck,
            onPressed: onCreate,
            iconSize: 48,
            style: IconButton.styleFrom(
              backgroundColor: ink,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: OutlinedButton.icon(
            onPressed: onTimer,
            icon: const Icon(Icons.timer_outlined),
            label: Text(l10n.timer, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class TimerChoicePage extends StatefulWidget {
  const TimerChoicePage({
    super.key,
    required this.decks,
    required this.onStudy,
  });
  final List<Deck> decks;
  final Future<void> Function(Deck, int) onStudy;
  @override
  State<TimerChoicePage> createState() => _TimerChoicePageState();
}

class _TimerChoicePageState extends State<TimerChoicePage> {
  Deck? selected;
  int minutes = 15;
  @override
  void initState() {
    super.initState();
    selected = widget.decks.isEmpty ? null : widget.decks.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.timer)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              Icon(
                Icons.timer_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.makeTimeToStudy,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              if (selected == null)
                Text(l10n.createDeckFirst)
              else ...[
                DropdownButtonFormField<Deck>(
                  initialValue: selected,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.studyDeck),
                  items: widget.decks
                      .map(
                        (deck) => DropdownMenuItem(
                          value: deck,
                          child: Text(
                            deck.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (deck) => setState(() => selected = deck),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 88,
                  child: FilledButton(
                    onPressed: () => widget.onStudy(selected!, 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.pomodoro,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(l10n.focusMinutes),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  initialValue: minutes,
                  decoration: InputDecoration(labelText: l10n.timerDuration),
                  items: [5, 10, 15, 30, 50, 60]
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(l10n.minutes(value)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => minutes = value!),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 72,
                  child: OutlinedButton(
                    onPressed: () => widget.onStudy(selected!, minutes),
                    child: Text(
                      l10n.timer,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.studyWithCountdown, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StudyTimerBar extends StatelessWidget {
  const StudyTimerBar({
    super.key,
    required this.seconds,
    required this.running,
    required this.enabled,
    required this.onToggle,
    required this.onReset,
  });
  final int seconds;
  final bool running;
  final bool enabled;
  final VoidCallback onToggle;
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(l10n.timer),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                tooltip: running ? l10n.pauseTimer : l10n.startTimer,
                onPressed: enabled && seconds > 0 ? onToggle : null,
                icon: Icon(running ? Icons.pause : Icons.play_arrow),
              ),
              Expanded(
                child: Text(
                  '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.resetTimer,
                onPressed: enabled ? onReset : null,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
