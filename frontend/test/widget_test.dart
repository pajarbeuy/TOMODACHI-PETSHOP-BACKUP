import 'package:flutter_test/flutter_test.dart';

import 'package:frontendd/main.dart';

void main() {
  testWidgets('shows Tomodachi API connection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TomodachiApp());
    await tester.pump();

    expect(find.text('Tomodachi Pet Shop'), findsOneWidget);
    expect(find.text('Base URL API'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Produk'), findsWidgets);
    expect(find.text('Kategori'), findsOneWidget);

    await tester.pump(const Duration(seconds: 11));
  });
}
