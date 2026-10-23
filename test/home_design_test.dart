import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifthapp/main.dart';
import 'package:fifthapp/mockup.dart';

import 'widget_test.dart' show localizedTestApp;

void main() {
  testWidgets('Timer selection is independent of beginning a session', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final first = Deck('First', [Flashcard('A', 'a'), Flashcard('B', 'b')]);
    final second = Deck('Second', [Flashcard('C', 'c'), Flashcard('D', 'd')]);
    final launches = <(Deck, int, StudyTimerMode)>[];
    await tester.pumpWidget(
      localizedTestApp(
        TimerChoicePage(
          decks: [first, second],
          onStudy: (deck, minutes, mode) async =>
              launches.add((deck, minutes, mode)),
        ),
      ),
    );
    for (final label in ['Open-ended', 'Flowtime', 'Pomodoro']) {
      await tester.tap(find.text(label).first);
      await tester.pumpAndSettle();
      expect(launches, isEmpty);
      final selected = find.ancestor(
        of: find.text(label).first,
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
      );
      expect(selected, findsOneWidget);
    }
    await tester.scrollUntilVisible(
      find.text('Begin studying'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byType(DropdownButtonFormField<Deck>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Second').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Begin studying'));
    await tester.pumpAndSettle();
    expect(launches.single, (second, 25, StudyTimerMode.pomodoro));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home stats survive reviews, edits, and reopening the app', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final deck = Deck(
      'Practice',
      [Flashcard('One', '1'), Flashcard('Two', '2')],
      seconds: 120,
      completedCards: 7,
    );
    SharedPreferences.setMockInitialValues({
      'studyspace.decks.v1': jsonEncode([deck.toJson()]),
    });
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
    expect(find.text('Decks created'), findsOneWidget);
    expect(find.text('Minutes studied'), findsOneWidget);
    expect(find.text('Flashcards completed'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flashcards'));
    await tester.pumpAndSettle();
    await tester.drag(find.text('One'), const Offset(200, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.text('Two'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to library'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit deck'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Edited');
    await tester.ensureVisible(find.text('Save deck'));
    await tester.tap(find.text('Save deck'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(find.text('9'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
    expect(find.text('9'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    final saved = jsonDecode(prefs.getString('studyspace.decks.v1')!) as List;
    expect(saved.single['completedCards'], 9);
    expect(saved.single['title'], 'Edited');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'Empty library disables starting and supports creating the first deck',
    (tester) async {
      SharedPreferences.setMockInitialValues({'studyspace.decks.v1': '[]'});
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Begin Studying!'));
      await tester.tap(find.text('Begin Studying!'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Begin studying'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Begin studying'),
      );
      expect(button.onPressed, isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Create new deck'), 200);
      await tester.tap(find.text('Create new deck'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('saveDeckButton')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
