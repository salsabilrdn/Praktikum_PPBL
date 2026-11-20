import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:aiot_peringatan_dini_sqlite/app.dart';
import 'package:aiot_peringatan_dini_sqlite/db/database_helper.dart';
import 'package:aiot_peringatan_dini_sqlite/models/pembacaan_sensor.dart';

void main() {
  testWidgets('Riwayat memperbarui koreksi, hapus, dan muat ulang', (
    tester,
  ) async {
    sqfliteFfiInit();
    final helper = DatabaseHelper.untukPengujian(
      databaseFactoryFfiNoIsolate,
      inMemoryDatabasePath,
    );
    addTearDown(helper.tutup);
    final waktu = DateTime.utc(2026, 11, 20);
    for (final item in [
      PembacaanSensor(
        jenisSensor: JenisSensor.ketinggianAir,
        nilai: 80,
        lokasiPos: 'Pos Air',
        waktu: waktu,
      ),
      PembacaanSensor(
        jenisSensor: JenisSensor.curahHujan,
        nilai: 60,
        lokasiPos: 'Pos Hujan',
        waktu: waktu.add(const Duration(minutes: 1)),
      ),
      PembacaanSensor(
        jenisSensor: JenisSensor.pergeseranTanah,
        nilai: 12,
        lokasiPos: 'Pos Tanah',
        waktu: waktu.add(const Duration(minutes: 2)),
      ),
    ]) {
      await helper.tambahPembacaan(item);
    }
    await tester.pumpWidget(AiotApp(database: helper));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Riwayat Sensor'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Koreksi pembacaan 3'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('edit_nilai')), '4');
    await tester.tap(find.text('Simpan Koreksi'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('4 mm'), findsOneWidget);
    expect(find.text('12 mm'), findsNothing);
    await tester.drag(find.byKey(const ValueKey<int?>(2)), const Offset(-600, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Pos Hujan'), findsNothing);
    expect(find.text('2 catatan'), findsOneWidget);
    await tester.tap(find.byTooltip('Muat ulang riwayat'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final rows = await helper.ambilSemuaPembacaan();
    expect(rows.map((x) => x.nilai), [4, 80]);
    await tester.pumpWidget(const SizedBox.shrink());
    await helper.tutup();
  });
  testWidgets('Validasi form, simpan desimal, tema, dan riwayat', (
    tester,
  ) async {
    sqfliteFfiInit();
    final helper = DatabaseHelper.untukPengujian(
      databaseFactoryFfiNoIsolate,
      inMemoryDatabasePath,
    );
    addTearDown(helper.tutup);
    await helper.database;
    await tester.pumpWidget(AiotApp(database: helper));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data'), findsOneWidget);
    await tester.tap(find.text('Tambah Pembacaan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Isi angka 0 atau lebih.'), findsOneWidget);
    expect(find.text('Lokasi wajib diisi.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('input_nilai')), '80,5');
    await tester.enterText(
      find.byKey(const Key('input_lokasi')),
      'Pos Dayeuhkolot',
    );
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('80.5 cm'), findsOneWidget);
    expect(find.text('1 catatan tersimpan'), findsOneWidget);
    await tester.tap(find.byTooltip('Mode gelap'));
    await tester.pumpAndSettle();
    expect(find.text('80.5 cm'), findsOneWidget);
    await tester.tap(find.byTooltip('Riwayat Sensor'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Sensor'), findsOneWidget);
    expect(find.text('Pos Dayeuhkolot'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await helper.tutup();
  });
}
