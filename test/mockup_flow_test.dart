import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fifthapp/main.dart';

void main() {
  testWidgets('Mockup flow opens Pomodoro flashcards with timer above card', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Guest'), findsOneWidget);
    await tester.ensureVisible(find.text('Begin Studying!'));
    await tester.tap(find.text('Begin Studying!'));
    await tester.pumpAndSettle();
    expect(find.text('Pomodoro'), findsOneWidget);
    expect(find.text('Open-ended'), findsOneWidget);
    expect(find.text('Flowtime'), findsOneWidget);
    final optionY = tester.getTopLeft(find.text('Pomodoro')).dy;
    expect(tester.getTopLeft(find.text('Open-ended')).dy, optionY);
    expect(tester.getTopLeft(find.text('Flowtime')).dy, optionY);
    await tester.tap(find.text('Pomodoro'));
    await tester.pumpAndSettle();
    expect(find.text('Mitochondria'), findsNothing);
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
    await tester.tap(find.text('Begin studying'));
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Mitochondria'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('25:00')).dy,
      lessThan(tester.getTopLeft(find.text('Mitochondria')).dy),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('24:59'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause focus timer'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('24:59'), findsOneWidget);
    await tester.tap(find.text('Mitochondria'));
    await tester.pumpAndSettle();
    expect(find.text('DEFINITION'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
