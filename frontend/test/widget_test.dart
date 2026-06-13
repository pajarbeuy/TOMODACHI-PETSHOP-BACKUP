import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontendd/main.dart';

void main() {
  testWidgets('shows splash screen then login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TomodachiApp());
    await tester.pump();

    expect(find.text('TOMODACHI'), findsOneWidget);
    expect(find.text('PETSHOP'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pumpAndSettle();

    expect(find.text('TOMODACHI PETSHOP'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
