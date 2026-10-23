import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifthapp/main.dart';
import 'package:fifthapp/mockup.dart';

import 'widget_test.dart' show localizedTestApp;

void main() {
  testWidgets(
    'Pomodoro accepts custom minutes and requires a positive duration',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      int? startedMinutes;
      await tester.pumpWidget(
        localizedTestApp(
          TimerChoicePage(
            decks: [
              Deck('Test', [Flashcard('One', '1')]),
            ],
            onStudy: (deck, minutes, mode) async => startedMinutes = minutes,
          ),
        ),
      );
      final duration = find.byType(TextFormField);
      final start = find.widgetWithText(FilledButton, 'Begin studying');
      await tester.enterText(duration, '37');
      await tester.pump();
      expect(find.text('37:00'), findsOneWidget);
      await tester.tap(start);
      expect(startedMinutes, 37);
      for (final value in ['', '0']) {
        await tester.enterText(duration, value);
        await tester.pump();
        expect(tester.widget<FilledButton>(start).onPressed, isNull);
      }
      await tester.enterText(duration, '42');
      await tester.pump();
      expect(tester.widget<FilledButton>(start).onPressed, isNotNull);
    },
  );

  for (final mode in [StudyTimerMode.openEnded, StudyTimerMode.flowtime]) {
    testWidgets('$mode counts up, pauses, resets and handles breaks', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        localizedTestApp(
          StudyPage(
            deck: Deck('Test', [Flashcard('One', '1'), Flashcard('Two', '2')]),
            quiz: false,
            timerMode: mode,
            autoStart: true,
          ),
        ),
      );
      expect(find.text('0:00'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('0:10'), findsOneWidget);
      await tester.tap(find.byTooltip('Pause focus timer'));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('0:10'), findsOneWidget);
      if (mode == StudyTimerMode.flowtime) {
        await tester.tap(find.text('Take a break'));
        await tester.pump();
        expect(find.text('Break'), findsOneWidget);
        expect(find.text('0:02'), findsOneWidget);
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('0:00'), findsOneWidget);
        await tester.tap(find.text('Start next focus session'));
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('0:01'), findsOneWidget);
      }
      await tester.tap(find.byTooltip('Reset timer'));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('0:00'), findsOneWidget);
      await tester.tap(find.byTooltip('Start focus timer'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('0:01'), findsOneWidget);
      await tester.drag(find.text('One'), const Offset(30, 0));
      await tester.pumpAndSettle();
      expect(find.text('One'), findsOneWidget);
      await tester.drag(find.text('One'), const Offset(200, 0));
      await tester.pumpAndSettle();
      expect(find.text('Two'), findsOneWidget);
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      await tester.drag(find.text('2'), const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(find.text('1 of 2 remembered'), findsOneWidget);
      await tester.tap(find.text('Retry 1 missed cards'));
      await tester.pumpAndSettle();
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('One'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
