import 'dart:convert';

import 'package:fifthapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storageKey = 'studyspace.decks.v1';

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> openLibrary(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), 'Alex');
  await tap(tester, find.text('Continue locally'));
}

Future<void> openStudy(
  WidgetTester tester, {
  bool quiz = false,
  int minutes = 25,
  bool autoStart = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: StudyPage(
        deck: Deck('Practice', [
          Flashcard('Greeting', 'Hello world'),
          Flashcard('Farewell', 'Goodbye'),
        ]),
        quiz: quiz,
        initialMinutes: minutes,
        autoStart: autoStart,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // A tall viewport keeps controls visible while exercising real widgets.
  Future<void> prepare(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() async => tester.pumpWidget(const SizedBox()));
  }

  testWidgets('Create, edit, reload, and search a persisted deck', (
    tester,
  ) async {
    await prepare(tester);
    await openLibrary(tester);
    await tap(tester, find.byTooltip('Create deck'));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Spanish');
    await tester.enterText(fields.at(1), 'Hola');
    await tester.enterText(fields.at(2), 'Hello');
    await tap(tester, find.text('Save deck'));
    await tester.enterText(find.byType(TextField), 'SPANISH');
    await tester.pumpAndSettle();
    expect(find.text('Spanish'), findsOneWidget);
    expect(find.text('Biology essentials'), findsNothing);
    await tap(tester, find.byTooltip('Edit deck'));
    await tester.enterText(find.byType(TextFormField).at(2), 'Hello world');
    await tap(tester, find.text('Save deck'));

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await openLibrary(tester);
    await tester.enterText(find.byType(TextField), 'spanish');
    await tester.pumpAndSettle();
    await tap(tester, find.byTooltip('Edit deck'));
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(1))
          .controller!
          .text,
      'Hola',
    );
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(2))
          .controller!
          .text,
      'Hello world',
    );
  });

  testWidgets('Tap and swipe flip cards; retry includes only missed cards', (
    tester,
  ) async {
    await prepare(tester);
    await openStudy(tester);
    await tap(tester, find.text('Greeting'));
    expect(find.text('Hello world'), findsOneWidget);
    await tap(tester, find.text('Got it'));
    await tester.drag(find.text('Farewell'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(find.text('Goodbye'), findsOneWidget);
    await tap(tester, find.text('Still learning'));
    expect(find.text('1 of 2 remembered'), findsOneWidget);
    await tap(tester, find.text('Retry 1 missed cards'));
    expect(find.text('Farewell'), findsOneWidget);
    expect(find.text('Greeting'), findsNothing);
    await tap(tester, find.text('Farewell'));
    await tap(tester, find.text('Got it'));
    expect(find.text('1 of 1 remembered'), findsOneWidget);
    expect(find.textContaining('missed cards'), findsNothing);
  });

  testWidgets('Quiz normalizes answers and retries only incorrect answers', (
    tester,
  ) async {
    await prepare(tester);
    await openStudy(tester, quiz: true);
    await tester.enterText(find.byType(TextField), '  HELLO   world  ');
    await tap(tester, find.text('Check answer'));
    expect(find.text('Correct!'), findsOneWidget);
    await tap(tester, find.text('Continue'));
    await tester.enterText(find.byType(TextField), 'wrong');
    await tap(tester, find.text('Check answer'));
    expect(find.text('Answer: Goodbye'), findsOneWidget);
    await tap(tester, find.text('Continue'));
    expect(find.text('1 of 2 correct'), findsOneWidget);
    await tap(tester, find.text('Retry 1 missed cards'));
    expect(find.text('Farewell'), findsOneWidget);
    expect(find.text('Greeting'), findsNothing);
    await tester.enterText(find.byType(TextField), 'goodbye');
    await tap(tester, find.text('Check answer'));
    await tap(tester, find.text('Continue'));
    expect(find.text('1 of 1 correct'), findsOneWidget);
  });

  testWidgets(
    '25, 50, and 5 minute timers count down, pause, resume, and reset',
    (tester) async {
      await prepare(tester);
      for (final minutes in [25, 50, 5]) {
        await tester.pumpWidget(const SizedBox());
        await openStudy(tester, minutes: minutes, autoStart: true);
        expect(find.text('$minutes:00'), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        final remaining = '${minutes - 1}:59';
        expect(find.text(remaining), findsOneWidget);
        await tester.tap(find.byTooltip('Pause focus timer'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));
        expect(find.text(remaining), findsOneWidget);
        await tester.tap(find.byTooltip('Start focus timer'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('${minutes - 1}:58'), findsOneWidget);
        await tester.tap(find.byTooltip('Reset timer'));
        await tester.pump();
        expect(find.text('$minutes:00'), findsOneWidget);
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('$minutes:00'), findsOneWidget);
      }
    },
  );

  testWidgets('Export/import preserves deck data and rejects malformed JSON', (
    tester,
  ) async {
    await prepare(tester);
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await openLibrary(tester);
    await tap(tester, find.byTooltip('Export deck'));
    expect(clipboard, isNotNull);
    final exported = jsonDecode(clipboard!) as Map<String, dynamic>;

    Future<void> import(String text) async {
      await tap(tester, find.byTooltip('Import deck'));
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        text,
      );
      await tap(tester, find.text('Import'));
    }

    await import(clipboard!);
    final prefs = await SharedPreferences.getInstance();
    final saved = jsonDecode(prefs.getString(storageKey)!) as List;
    expect(saved, hasLength(2));
    expect(saved.last, equals(exported));
    expect(find.text('2 decks'), findsOneWidget);
    final before = prefs.getString(storageKey);
    ScaffoldMessenger.of(tester.element(find.text('2 decks'))).clearSnackBars();
    await tester.pumpAndSettle();
    await import('{invalid json');
    expect(
      find.text('Invalid deck. Paste a complete StudySpace export.'),
      findsOneWidget,
    );
    expect(prefs.getString(storageKey), before);
    expect(find.text('2 decks'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
