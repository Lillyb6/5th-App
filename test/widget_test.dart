import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifthapp/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Create a deck and save it to the library', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Alex');
    await tester.tap(find.text('Continue locally'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Create deck'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Spanish');
    await tester.enterText(fields.at(1), 'Hola');
    await tester.enterText(fields.at(2), 'Hello');
    await tester.ensureVisible(find.text('Save deck'));
    await tester.tap(find.text('Save deck'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Spanish'),
      250,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Spanish'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('studyspace.decks.v1'), contains('Hola'));
  });
  testWidgets(
    'Quiz records an incorrect answer and retries only missed cards',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final deck = Deck('Test', [Flashcard('One', '1'), Flashcard('Two', '2')]);
      await tester.pumpWidget(
        MaterialApp(home: StudyPage(deck: deck, quiz: true)),
      );
      await tester.enterText(find.byType(TextField), 'wrong');
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      expect(find.text('Answer: 1'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), ' 2 ');
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(find.text('1 of 2 correct'), findsOneWidget);
      await tester.tap(find.text('Retry 1 missed cards'));
      await tester.pump();
      expect(find.text('Quiz • 1 of 1'), findsOneWidget);
      expect(find.text('One'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
