import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifthapp/main.dart';

import 'package:fifthapp/l10n/app_localizations.dart';

Widget localizedTestApp(Widget home) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Decks require at least two cards before saving', (tester) async {
    await tester.pumpWidget(localizedTestApp(EditorPage()));
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(5));
    await tester.enterText(fields.at(0), 'Spanish');
    await tester.enterText(fields.at(1), 'Hola');
    await tester.enterText(fields.at(2), 'Hello');
    final saveButton = tester.widget<FilledButton>(
      find.byKey(const Key('saveDeckButton')),
    );
    saveButton.onPressed!();
    await tester.pump();
    expect(find.text('A deck needs at least 2 cards.'), findsOneWidget);
  });

  testWidgets(
    'Quiz lets players choose the correct term from multiple choices',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final deck = Deck('Test', [Flashcard('One', '1'), Flashcard('Two', '2')]);
      await tester.pumpWidget(
        localizedTestApp(StudyPage(deck: deck, quiz: true)),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Two'));
      await tester.pump();
      expect(find.text('Not quite. The correct term is One.'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Two'));
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(find.text('1 of 2 correct'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
