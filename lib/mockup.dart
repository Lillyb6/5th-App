import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'main.dart';

const ink = Color(0xff4338ca);

enum _EntryMode { welcome, signIn, signUp }

class EntryPage extends StatefulWidget {
  const EntryPage({
    super.key,
    required this.onSettings,
    this.supabaseEnabled = false,
  });
  final VoidCallback onSettings;
  final bool supabaseEnabled;
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
  void initState() {
    super.initState();
    if (widget.supabaseEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final user = Supabase.instance.client.auth.currentUser;
        if (mounted && user != null) {
          openLibrary(
            username: user.email?.split('@').first ?? user.id,
            storageKey: '',
            remoteUserId: user.id,
          );
        }
      });
    }
  }

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
    String? remoteUserId,
  }) {
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => LibraryPage(
          username: username,
          storageKey: storageKey,
          initialDecks: initialDecks,
          remoteUserId: remoteUserId,
          onSettings: widget.onSettings,
          onSignOut: () async {
            if (widget.supabaseEnabled) {
              await Supabase.instance.client.auth.signOut();
            }
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => EntryPage(
                  onSettings: widget.onSettings,
                  supabaseEnabled: widget.supabaseEnabled,
                ),
              ),
              (_) => false,
            );
          },
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
      if (widget.supabaseEnabled) {
        final client = Supabase.instance.client;
        final response = mode == _EntryMode.signUp
            ? await client.auth.signUp(email: username, password: password.text)
            : await client.auth.signInWithPassword(
                email: username,
                password: password.text,
              );
        if (!mounted) {
          return;
        }
        final signedInUser = response.user;
        if (signedInUser == null) {
          showMessage(l10n.invalidCredentials);
          return;
        }
        if (response.session == null) {
          showMessage(l10n.emailConfirmation);
          setState(() => mode = _EntryMode.signIn);
          return;
        }
        openLibrary(
          username: signedInUser.email?.split('@').first ?? signedInUser.id,
          storageKey: '',
          remoteUserId: signedInUser.id,
        );
        return;
      }
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
      showMessage(
        widget.supabaseEnabled
            ? l10n.authRequestError(error.toString())
            : l10n.accountStorageError(error.toString()),
      );
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
                      Icons.auto_awesome_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Study Space',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.tagline),
                  const SizedBox(height: 32),
                  if (mode == _EntryMode.welcome) ...[
                    Text(
                      widget.supabaseEnabled
                          ? l10n.supabaseSignInHint
                          : l10n.demoCredentials,
                      textAlign: TextAlign.center,
                    ),
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
                    Text(
                      widget.supabaseEnabled
                          ? l10n.supabaseNotice
                          : l10n.localOnlyNotice,
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Form(
                      key: form,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: user,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().length < 3) {
                                return widget.supabaseEnabled
                                    ? l10n.emailInvalid
                                    : l10n.minimumUsername;
                              }
                              if (widget.supabaseEnabled &&
                                  (!value.contains('@') ||
                                      !value.split('@').last.contains('.'))) {
                                return l10n.emailInvalid;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: widget.supabaseEnabled
                                  ? l10n.email
                                  : l10n.username,
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

class StudyHome extends StatelessWidget {
  const StudyHome({
    super.key,
    required this.username,
    required this.decks,
    required this.onLibrary,
    required this.onStudy,
    required this.onCreate,
  });
  final String username;
  final List<Deck> decks;
  final VoidCallback onLibrary;
  final VoidCallback onStudy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          children: [
            Text(
              l10n.hiUser(username),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.nights_stay_outlined,
                    color: colors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.yourLearningCorner,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Study Space', style: theme.textTheme.displaySmall),
            const SizedBox(height: 10),
            Text(
              l10n.homeDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.outlineVariant),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeStat(
                    value: decks.length,
                    label: l10n.decksCreated,
                    icon: Icons.layers_outlined,
                  ),
                  _HomeStat(
                    value:
                        decks.fold<int>(0, (sum, deck) => sum + deck.seconds) ~/
                        60,
                    label: l10n.statMinutesStudied,
                    icon: Icons.schedule_rounded,
                  ),
                  _HomeStat(
                    value: decks.fold<int>(
                      0,
                      (sum, deck) => sum + deck.completedCards,
                    ),
                    label: l10n.flashcardsCompleted,
                    icon: Icons.done_all_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.makeALittleProgress, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff5056c9), Color(0xff37318a)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: InkWell(
                  onTap: onStudy,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.beginStudyingHome,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.chooseYourRhythm,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xffe0e7ff),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final tiles = [
                  _HomeAction(
                    title: l10n.library,
                    subtitle: l10n.libraryShortcut,
                    icon: Icons.auto_stories_outlined,
                    onTap: onLibrary,
                  ),
                  _HomeAction(
                    title: l10n.createNewDeck,
                    subtitle: l10n.createShortcut,
                    icon: Icons.add_rounded,
                    onTap: onCreate,
                  ),
                ];
                if (constraints.maxWidth < 500) {
                  return Column(
                    children: [tiles[0], const SizedBox(height: 12), tiles[1]],
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: tiles[0]),
                      const SizedBox(width: 16),
                      Expanded(child: tiles[1]),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 14,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.smallSteps,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeStat extends StatelessWidget {
  const _HomeStat({
    required this.value,
    required this.label,
    required this.icon,
  });
  final int value;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Icon(icon, size: 21, color: theme.colorScheme.primary),
            const SizedBox(height: 10),
            Text('$value', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
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
  final Future<void> Function(Deck, int, StudyTimerMode) onStudy;
  @override
  State<TimerChoicePage> createState() => _TimerChoicePageState();
}

class _TimerChoicePageState extends State<TimerChoicePage> {
  Deck? selected;
  int minutes = 25;
  StudyTimerMode mode = StudyTimerMode.pomodoro;
  @override
  void initState() {
    super.initState();
    selected = widget.decks.isEmpty ? null : widget.decks.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final description = switch (mode) {
      StudyTimerMode.pomodoro => l10n.pomodoroDescription,
      StudyTimerMode.openEnded => l10n.openEndedDescription,
      StudyTimerMode.flowtime => l10n.flowtimeDescription,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.studySession)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Text(l10n.findYourFlow, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                l10n.timerIntro,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              Text(l10n.chooseTimer, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final option in StudyTimerMode.values) ...[
                      if (option != StudyTimerMode.values.first)
                        const SizedBox(width: 8),
                      Expanded(
                        child: _TimerOption(
                          selected: mode == option,
                          label: switch (option) {
                            StudyTimerMode.pomodoro => l10n.pomodoro,
                            StudyTimerMode.openEnded => l10n.openEnded,
                            StudyTimerMode.flowtime => l10n.flowtimeShort,
                          },
                          icon: switch (option) {
                            StudyTimerMode.pomodoro => Icons.timelapse_rounded,
                            StudyTimerMode.openEnded =>
                              Icons.all_inclusive_rounded,
                            StudyTimerMode.flowtime => Icons.waves_rounded,
                          },
                          onTap: () => setState(() => mode = option),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  children: [
                    Text(
                      mode == StudyTimerMode.pomodoro
                          ? l10n.focusSession
                          : mode == StudyTimerMode.flowtime
                          ? l10n.flowtime
                          : l10n.openEnded,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mode == StudyTimerMode.pomodoro ? '$minutes:00' : '0:00',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 56,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (mode == StudyTimerMode.pomodoro) ...[
                      const SizedBox(height: 22),
                      DropdownButtonFormField<int>(
                        initialValue: minutes,
                        decoration: InputDecoration(
                          labelText: l10n.timerDuration,
                        ),
                        items: [5, 10, 15, 25, 30, 50, 60]
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(l10n.minutes(value)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => minutes = value!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (selected == null)
                Text(l10n.createDeckFirst)
              else
                DropdownButtonFormField<Deck>(
                  initialValue: selected,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.studyDeck,
                    prefixIcon: const Icon(Icons.layers_outlined),
                  ),
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
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: selected == null
                    ? null
                    : () => widget.onStudy(
                        selected!,
                        mode == StudyTimerMode.pomodoro ? minutes : 0,
                        mode,
                      ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.beginStudying),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerOption extends StatelessWidget {
  const _TimerOption({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = selected ? Colors.white : colors.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff5357cf) : colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xff9295ff) : colors.outlineVariant,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: foreground, size: 28),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: foreground,
                    size: 18,
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

class StudyTimerBar extends StatelessWidget {
  const StudyTimerBar({
    super.key,
    required this.seconds,
    this.countsUp = false,
    this.label,
    required this.running,
    required this.enabled,
    required this.onToggle,
    required this.onReset,
  });
  final int seconds;
  final bool countsUp;
  final String? label;
  final bool running;
  final bool enabled;
  final VoidCallback onToggle;
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(label ?? l10n.timer),
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
                onPressed: enabled && (countsUp || seconds > 0)
                    ? onToggle
                    : null,
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
