import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kantin_kampus_sqlite/widgets/cart_summary_bar.dart';

void main() {
  testWidgets('ringkasan keranjang muat pada layar HP 360 piksel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CartSummaryBar(
            totalItem: 12,
            totalHarga: 180000,
            onKosongkan: () {},
            onCheckout: () {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Kosongkan'), findsOneWidget);
  });
}
