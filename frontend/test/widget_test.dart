import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontendd/main.dart';

void main() {
  test('TomodachiApp is a stateless widget', () {
    expect(const TomodachiApp(), isA<StatelessWidget>());
  });

  test('TomodachiApp builds a MaterialApp shell', () {
    final app = const TomodachiApp().build(_FakeBuildContext()) as MaterialApp;

    expect(app.debugShowCheckedModeBanner, isFalse);
    expect(app.title, 'Tomodachi Pet Shop');
  });
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
