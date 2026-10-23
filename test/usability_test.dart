import 'package:fifthapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application_checks_test.dart' show librarySearchField;
import 'widget_test.dart' show localizedTestApp;

Future<void> tap(WidgetTester tester, Finder finder) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> prepare(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() async => tester.pumpWidget(const SizedBox()));
  }

  Future<void> openLibrary(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tap(tester, find.text('Continue as guest'));
    await tester.scrollUntilVisible(find.text('Library'), 200);
    await tap(tester, find.text('Library'));
  }

  testWidgets('Invalid sign-in can be corrected without leaving the form', (
    tester,
  ) async {
    await prepare(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tap(tester, find.text('Sign in'));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, 'demo');
    await tester.enterText(fields.last, 'wrongpassword');
    await tap(tester, find.widgetWithText(FilledButton, 'Sign in'));
    expect(find.text('Username or password is incorrect.'), findsOneWidget);
    expect(tester.widget<TextFormField>(fields.first).controller!.text, 'demo');
    await tester.enterText(fields.last, 'studyspace123');
    await tap(tester, find.widgetWithText(FilledButton, 'Sign in'));
    expect(find.text('Hi, demo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty search recovers when the query is cleared', (
    tester,
  ) async {
    await prepare(tester);
    await openLibrary(tester);
    await tester.enterText(librarySearchField, 'no matching deck');
    await tester.pumpAndSettle();
    expect(
      find.text('No decks found. Create a deck to get started.'),
      findsOneWidget,
    );
    expect(find.text('Biology essentials'), findsNothing);
    await tester.enterText(librarySearchField, '');
    await tester.pumpAndSettle();
    expect(find.text('Biology essentials'), findsOneWidget);
    expect(find.byTooltip('Edit deck'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cancelling an edit preserves the saved deck', (tester) async {
    await prepare(tester);
    await openLibrary(tester);
    final prefs = await SharedPreferences.getInstance();
    final before = prefs.getString('studyspace.decks.v1');
    await tap(tester, find.byTooltip('Edit deck'));
    await tester.enterText(find.byType(TextFormField).first, 'Unsaved title');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Biology essentials'), findsOneWidget);
    expect(find.text('Unsaved title'), findsNothing);
    expect(prefs.getString('studyspace.decks.v1'), before);
    await tap(tester, find.byTooltip('Edit deck'));
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'Biology essentials',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Whitespace validation lets users correct and save a new deck', (
    tester,
  ) async {
    await prepare(tester);
    await openLibrary(tester);
    await tap(tester, find.byTooltip('Create deck'));
    final fields = find.byType(TextFormField);
    for (var index = 0; index < 5; index++) {
      await tester.ensureVisible(fields.at(index));
      await tester.enterText(fields.at(index), '   ');
    }
    await tap(tester, find.text('Save deck'));
    expect(find.text('Please enter some text'), findsNWidgets(5));
    expect(find.byKey(const Key('saveDeckButton')), findsOneWidget);
    ScaffoldMessenger.of(tester.element(find.byType(Form))).clearSnackBars();
    await tester.pumpAndSettle();
    final values = [
      '  Greetings  ',
      ' Hola ',
      ' Hello ',
      ' Adios ',
      ' Goodbye ',
    ];
    for (var index = 0; index < values.length; index++) {
      await tester.ensureVisible(fields.at(index));
      await tester.enterText(fields.at(index), values[index]);
    }
    await tap(tester, find.text('Save deck'));
    await tester.enterText(librarySearchField, 'Greetings');
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == 'Greetings'),
      findsOneWidget,
    );
    await tap(tester, find.byTooltip('Edit deck'));
    expect(tester.widget<TextFormField>(fields.at(1)).controller!.text, 'Hola');
    expect(
      tester.widget<TextFormField>(fields.at(2)).controller!.text,
      'Hello',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Adding and removing a card preserves the remaining input', (
    tester,
  ) async {
    await prepare(tester);
    await tester.pumpWidget(localizedTestApp(const EditorPage()));
    await tester.enterText(find.byType(TextFormField).at(1), 'Keep this term');
    for (final element
        in find
            .byWidgetPredicate(
              (w) => w is IconButton && w.tooltip == 'Remove card',
            )
            .evaluate()) {
      expect((element.widget as IconButton).onPressed, isNull);
    }
    await tap(tester, find.text('Add card'));
    expect(find.byType(TextFormField), findsNWidgets(7));
    await tap(tester, find.byTooltip('Remove card').last);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(1))
          .controller!
          .text,
      'Keep this term',
    );
    for (final element
        in find
            .byWidgetPredicate(
              (w) => w is IconButton && w.tooltip == 'Remove card',
            )
            .evaluate()) {
      expect((element.widget as IconButton).onPressed, isNull);
    }
    expect(tester.takeException(), isNull);
  });
}
