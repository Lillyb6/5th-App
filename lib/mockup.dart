import 'package:flutter/material.dart';

import 'main.dart';

const ink = Color(0xff93445f);

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});
  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final user = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    user.dispose();
    super.dispose();
  }

  void enter() {
    if (form.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LibraryPage(username: user.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 144,
                    height: 144,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xfff3dce4),
                      border: Border.all(color: ink, width: 2),
                    ),
                    child: const Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 108,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'StudySpace',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(color: ink, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Make a little room for learning.'),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: user,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => enter(),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'User',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    enabled: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      helperText: 'Server login is not connected yet.',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: enter,
                      child: const Text('Continue locally'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your decks are saved on this device.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class HomeActions extends StatelessWidget {
  const HomeActions({super.key, required this.onCreate, required this.onTimer});
  final VoidCallback? onCreate;
  final VoidCallback? onTimer;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 12),
      Text('Create', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      SizedBox(
        width: 88,
        height: 88,
        child: IconButton.filled(
          tooltip: 'Create deck',
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
          label: const Text('Timer', style: TextStyle(fontSize: 22)),
        ),
      ),
      const SizedBox(height: 32),
    ],
  );
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Timer')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            const Icon(Icons.timer_outlined, size: 64, color: ink),
            const SizedBox(height: 24),
            Text(
              'Make time to study',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            if (selected == null)
              const Text(
                'Create a deck first, then come back to start a timed flashcard session.',
              )
            else ...[
              DropdownButtonFormField<Deck>(
                initialValue: selected,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Study deck'),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pomodoro', style: TextStyle(fontSize: 24)),
                      Text('25 minutes of focus'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<int>(
                initialValue: minutes,
                decoration: const InputDecoration(labelText: 'Timer duration'),
                items: [5, 10, 15, 30, 50, 60]
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value minutes'),
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
                  child: const Text('Timer', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Study flashcards with the countdown at the top.',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    ),
  );
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
  Widget build(BuildContext context) => Column(
    children: [
      const Text('Timer'),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: const Color(0xfff3dce4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ink),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              tooltip: running ? 'Pause focus timer' : 'Start focus timer',
              onPressed: enabled && seconds > 0 ? onToggle : null,
              icon: Icon(running ? Icons.pause : Icons.play_arrow),
            ),
            Expanded(
              child: Text(
                '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: ink, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              tooltip: 'Reset timer',
              onPressed: enabled ? onReset : null,
              icon: const Icon(Icons.restart_alt),
            ),
          ],
        ),
      ),
    ],
  );
}
