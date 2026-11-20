import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:kantin_kampus_sqlite/db/database_helper.dart';
import 'package:kantin_kampus_sqlite/main.dart';

void main() {
  late Directory testDirectory;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
    testDirectory = await Directory.systemTemp.createTemp(
      'kantin_sqlite_test_',
    );
    await databaseFactory.setDatabasesPath(testDirectory.path);
  });

  tearDownAll(() async {
    final db = await DatabaseHelper.instance.database;
    if (db.isOpen) await db.close();
    await testDirectory.delete(recursive: true);
  });

  testWidgets('Checkout tersimpan dan tampil di riwayat', (tester) async {
    await tester.runAsync(() async {
      await DatabaseHelper.instance.database;
    });
    await tester.pumpWidget(const KantinKampusApp());

    final tambahProduk = find.byIcon(Icons.add_circle);
    await tester.tap(tambahProduk.at(0));
    await tester.tap(tambahProduk.at(0));
    await tester.tap(tambahProduk.at(1));
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();
    expect(find.text('3 item • Rp35000'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan berhasil disimpan.'), findsOneWidget);
    expect(find.text('0 item • Rp0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.receipt_long));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Pesanan'), findsOneWidget);
    expect(find.text('Nasi Goreng, Es Teh Manis'), findsOneWidget);
    expect(find.text('Rp35000'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Buka ulang berkas SQLite untuk memastikan pesanan tersimpan di disk.
    await tester.runAsync(() async {
      final db = await DatabaseHelper.instance.database;
      await db.close();
      final reopened = await databaseFactory.openDatabase(
        p.join(testDirectory.path, 'kantin_kampus.db'),
      );
      try {
        final rows = await reopened.query('pesanan');
        expect(rows, hasLength(1));
        expect(rows.single['ringkasan_item'], 'Nasi Goreng, Es Teh Manis');
        expect(rows.single['total_item'], 3);
        expect(rows.single['total_harga'], 35000);
      } finally {
        await reopened.close();
      }
    });
  });
}
