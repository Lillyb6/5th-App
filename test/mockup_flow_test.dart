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
    await tester.enterText(find.byType(TextFormField), 'Sam');
    await tester.tap(find.text('Continue locally'));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Sam'), findsOneWidget);
    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
    expect(find.text('Pomodoro'), findsOneWidget);
    await tester.tap(find.text('Pomodoro'));
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
