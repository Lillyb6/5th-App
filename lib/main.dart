import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'mockup.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class Flashcard {
  Flashcard(this.term, this.answer);
  final String term;
  final String answer;
  Map<String, dynamic> toJson() => {'term': term, 'answer': answer};
}

class Deck {
  Deck(this.title, this.cards, {this.seconds = 0});
  String title;
  List<Flashcard> cards;
  int seconds;
  Map<String, dynamic> toJson() => {
    'title': title,
    'cards': cards.map((c) => c.toJson()).toList(),
    'seconds': seconds,
  };
  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
    json['title'] as String,
    (json['cards'] as List)
        .map((c) => Flashcard(c['term'] as String, c['answer'] as String))
        .toList(),
    seconds: json['seconds'] as int? ?? 0,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'StudySpace',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: ink),
      scaffoldBackgroundColor: const Color(0xfff8f9ff),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const EntryPage(),
  );
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, this.username = 'Learner'});
  final String username;
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Deck> decks = [];
  bool loading = true;
  String search = '';
  String? storageError;
  Future<void> writes = Future.value();
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('studyspace.decks.v1');
      decks = saved == null
          ? [
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
            ]
          : (jsonDecode(saved) as List).map((d) => Deck.fromJson(d)).toList();
    } catch (_) {
      storageError = 'Saved decks could not be loaded. Restart the app before making changes.';
    }
    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> save() {
    final snapshot = jsonEncode(decks.map((d) => d.toJson()).toList());
    writes = writes.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setString('studyspace.decks.v1', snapshot)) {
          throw StateError('Save failed');
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not save changes on this device.'),
            ),
          );
        }
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

  Future<void> study(Deck deck, bool quiz, {int? minutes}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudyPage(
          deck: deck,
          quiz: quiz,
          initialMinutes: minutes ?? 25,
          autoStart: minutes != null,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
      await save();
    }
  }

  Future<void> importDeck() async {
    final input = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import a deck'),
        content: TextField(
          controller: input,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'Paste exported deck JSON',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text),
            child: const Text('Import'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid deck. Paste a complete StudySpace export.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('StudySpace'),
      actions: [
        IconButton(
          tooltip: 'Import deck',
          onPressed: loading || storageError != null ? null : importDeck,
          icon: const Icon(Icons.file_download_outlined),
        ),
        const SizedBox(width: 12),
      ],
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : storageError != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(storageError!),
            ),
          )
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                children: [
                  Text(
                    'Hi, ${widget.username}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  HomeActions(
                    onCreate: () => edit(),
                    onTimer: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TimerChoicePage(
                            decks: decks,
                            onStudy: (deck, minutes) =>
                                study(deck, false, minutes: minutes),
                          ),
                        ),
                      );
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Chip(
                        label: Text('${decks.length} decks'),
                        avatar: const Icon(Icons.style_outlined),
                      ),
                      Chip(
                        label: Text(
                          '${decks.fold<int>(0, (n, d) => n + d.cards.length)} flashcards',
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${decks.fold<int>(0, (n, d) => n + d.seconds) ~/ 60} minutes studied',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    onChanged: (value) => setState(() => search = value),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search your decks',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your library',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (decks
                      .where(
                        (d) => d.title.toLowerCase().contains(
                          search.toLowerCase(),
                        ),
                      )
                      .isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No decks found. Create a deck to get started.',
                      ),
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
                                    const Icon(Icons.style, color: ink),
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
                                      tooltip: 'Edit deck',
                                      onPressed: () => edit(deck),
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Export deck',
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(
                                            text: const JsonEncoder.withIndent(
                                              '  ',
                                            ).convert(deck.toJson()),
                                          ),
                                        );
                                        if (!context.mounted) {
                                          return;
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Deck JSON copied. Paste it into a file or share it for import.',
                                                ),
                                              ),
                                            );
                                      },
                                      icon: const Icon(Icons.ios_share),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${deck.cards.length} cards • ${deck.seconds ~/ 60} minutes studied',
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
                                      label: const Text('Flashcards'),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () => study(deck, true),
                                      icon: const Icon(Icons.quiz_outlined),
                                      label: const Text('Take quiz'),
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
  );
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

  String? requiredText(String? text) =>
      text == null || text.trim().isEmpty ? 'Please enter some text' : null;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.deck == null ? 'New deck' : 'Edit deck')),
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
                  validator: requiredText,
                  decoration: const InputDecoration(labelText: 'Title'),
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
                                Expanded(child: Text('Card ${entry.$1 + 1}')),
                                IconButton(
                                  tooltip: 'Remove card',
                                  onPressed: cards.length <= 2
                                      ? null
                                      : () {
                                          setState(() => cards.removeAt(entry.$1));
                                        },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: entry.$2.$1,
                              validator: requiredText,
                              decoration: const InputDecoration(labelText: 'Term'),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: entry.$2.$2,
                              validator: requiredText,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Definition',
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
                  label: const Text('Add card'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('saveDeckButton'),
                  onPressed: () {
                    final deckCards = cards
                        .map(
                          (c) => Flashcard(c.$1.text.trim(), c.$2.text.trim()),
                        )
                        .toList();
                    if (form.currentState!.validate() && deckCards.length >= 2) {
                      Navigator.pop(
                        context,
                        Deck(
                          title.text.trim(),
                          deckCards,
                          seconds: widget.deck?.seconds ?? 0,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('A deck needs at least 2 cards.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save deck'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class StudyPage extends StatefulWidget {
  const StudyPage({
    super.key,
    required this.deck,
    required this.quiz,
    this.initialMinutes = 25,
    this.autoStart = false,
  });
  final int initialMinutes;
  final bool autoStart;
  final Deck deck;
  final bool quiz;
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> with WidgetsBindingObserver {
  late List<Flashcard> round;
  final List<Flashcard> missed = [];
  final answer = TextEditingController();
  final watch = Stopwatch();
  Timer? timer;
  int index = 0;
  int focusSeconds = 25 * 60;
  bool focusRunning = false;
  bool flipped = false;
  bool complete = false;
  bool? correct;
  bool active = true;
  @override
  void initState() {
    super.initState();
    round = List.of(widget.deck.cards);
    focusSeconds = widget.initialMinutes * 60;
    focusRunning = widget.autoStart;
    watch.start();
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !active || complete) {
        return;
      }
      setState(() {
        if (focusRunning && focusSeconds > 0) {
          focusSeconds--;
          if (focusSeconds == 0) {
            focusRunning = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Focus session complete. Take a break!'),
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
      if (!known) {
        missed.add(round[index]);
      }
      if (index == round.length - 1) {
        complete = true;
        watch.stop();
        focusRunning = false;
      } else {
        index++;
      }
      flipped = false;
      correct = null;
      answer.clear();
    });
  }

  List<String> buildQuizOptions() {
    final currentTerm = round[index].term;
    final distractors = round
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.deck.title)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            StudyTimerBar(
              seconds: focusSeconds,
              running: focusRunning,
              enabled: !complete,
              onToggle: () => setState(() => focusRunning = !focusRunning),
              onReset: () => setState(() {
                focusSeconds = widget.initialMinutes * 60;
                focusRunning = false;
              }),
            ),
            const SizedBox(height: 8),
            Text(
              'Study time ${duration(watch.elapsed.inSeconds)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (complete) ...[
              const Icon(Icons.celebration_outlined, size: 64, color: ink),
              const SizedBox(height: 16),
              Text(
                'Session complete',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${round.length - missed.length} of ${round.length} ${widget.quiz ? 'correct' : 'remembered'}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (missed.isNotEmpty)
                FilledButton(
                  onPressed: () => setState(() {
                    round = List.of(missed);
                    missed.clear();
                    index = 0;
                    complete = false;
                    watch.start();
                  }),
                  child: Text('Retry ${missed.length} missed cards'),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to library'),
              ),
            ] else ...[
              Text(
                '${widget.quiz ? 'Quiz' : 'Flashcards'} • ${index + 1} of ${round.length}',
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: index / round.length),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: widget.quiz
                    ? null
                    : () => setState(() => flipped = !flipped),
                onHorizontalDragEnd: widget.quiz
                    ? null
                    : (_) => setState(() => flipped = !flipped),
                child: Semantics(
                  button: !widget.quiz,
                  label: widget.quiz ? 'Question' : 'Tap to flip flashcard',
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
                              flipped ? 'DEFINITION' : 'TERM',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              flipped ? round[index].answer : round[index].term,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (!widget.quiz) ...[
                              const SizedBox(height: 24),
                              const Text('Tap or swipe to flip'),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (widget.quiz) ...[
                Text(
                  'Which term matches this definition?',
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
                  ...buildQuizOptions().map(
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
                    correct! ? 'Correct!' : 'Not quite. The correct term is ${round[index].term}.',
                    style: TextStyle(
                      color: correct!
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => next(correct!),
                    child: const Text('Continue'),
                  ),
                ],
              ] else ...[
                OutlinedButton.icon(
                  onPressed: () => setState(() => flipped = !flipped),
                  icon: const Icon(Icons.flip),
                  label: const Text('Flip card'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: flipped ? () => next(false) : null,
                        child: const Text('Still learning'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: flipped ? () => next(true) : null,
                        child: const Text('Got it'),
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
