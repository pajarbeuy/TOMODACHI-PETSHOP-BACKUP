import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontendd/main.dart';

void main() {
  test('TomodachiApp is a stateless widget', () {
    expect(const TomodachiApp(), isA<StatelessWidget>());
  });

  testWidgets('TomodachiApp builds MaterialApp shell correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TomodachiApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.debugShowCheckedModeBanner, isFalse);
    expect(materialApp.title, 'Tomodachi Pet Shop');

    // Advance 4 seconds to complete splash screen navigation without timing out infinite progress spinner
    await tester.pump(const Duration(seconds: 4));
  });
}
