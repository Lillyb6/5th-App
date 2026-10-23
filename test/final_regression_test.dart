import 'dart:convert';

import 'package:fifthapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application_checks_test.dart' show openLibrary, tap;
import 'widget_test.dart' show localizedTestApp;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> prepare(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() async => tester.pumpWidget(const SizedBox()));
  }

  testWidgets('Quiz retry refreshes choices and clears previous feedback', (
    tester,
  ) async {
    await prepare(tester);
    await tester.pumpWidget(
      localizedTestApp(
        StudyPage(
          deck: Deck('Retry', [
            Flashcard('One', 'First'),
            Flashcard('Two', 'Second'),
          ]),
          quiz: true,
        ),
      ),
    );
    await tap(tester, find.widgetWithText(FilledButton, 'Two'));
    await tap(tester, find.text('Continue'));
    await tap(tester, find.widgetWithText(FilledButton, 'Two'));
    await tap(tester, find.text('Continue'));
    expect(find.text('1 of 2 correct'), findsOneWidget);
    await tap(tester, find.text('Retry 1 missed cards'));
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsNothing);
    expect(find.text('Correct!'), findsNothing);
    expect(find.textContaining('Not quite.'), findsNothing);
    expect(find.text('TERM'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Two'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'One'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.widgetWithText(FilledButton, 'One'), findsOneWidget);
    await tap(tester, find.widgetWithText(FilledButton, 'One'));
    await tap(tester, find.text('Continue'));
    expect(find.text('1 of 1 correct'), findsOneWidget);
    expect(find.textContaining('missed cards'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Countdown finishes at zero and study cards remain usable', (
    tester,
  ) async {
    await prepare(tester);
    await tester.pumpWidget(
      localizedTestApp(
        StudyPage(
          deck: Deck('Focus', [
            Flashcard('One', 'First'),
            Flashcard('Two', 'Second'),
          ]),
          quiz: false,
          initialMinutes: 1,
          autoStart: true,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 60));
    await tester.pump();
    expect(find.text('0:00'), findsOneWidget);
    expect(find.text('Focus session complete. Take a break!'), findsOneWidget);
    expect(find.byTooltip('Start focus timer'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('0:00'), findsOneWidget);
    await tap(tester, find.text('One'));
    expect(find.text('First'), findsOneWidget);
    await tap(tester, find.text('Got it'));
    expect(find.text('Two'), findsOneWidget);
    await tap(tester, find.byTooltip('Reset timer'));
    expect(find.text('1:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Cancelling a valid import leaves library and storage unchanged',
    (tester) async {
      await prepare(tester);
      final original = jsonEncode([
        Deck('Existing', [
          Flashcard('One', 'First'),
          Flashcard('Two', 'Second'),
        ]).toJson(),
      ]);
      SharedPreferences.setMockInitialValues({'studyspace.decks.v1': original});
      await openLibrary(tester);
      await tap(tester, find.byTooltip('Import deck'));
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        jsonEncode(
          Deck('Cancelled', [
            Flashcard('A', 'a'),
            Flashcard('B', 'b'),
          ]).toJson(),
        ),
      );
      await tap(tester, find.text('Cancel'));
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Existing'), findsOneWidget);
      expect(find.text('Cancelled'), findsNothing);
      expect(find.text('1 deck'), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('studyspace.decks.v1'), original);
      // Reopening import also starts with a fresh input field.
      await tap(tester, find.byTooltip('Import deck'));
      final input = tester.widget<TextField>(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
      );
      expect(input.controller!.text, isEmpty);
      await tap(tester, find.text('Cancel'));
      expect(tester.takeException(), isNull);
    },
  );
}
