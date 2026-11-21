import 'dart:io';

import 'package:aiot_peringatan_dini_hive/app.dart';
import 'package:aiot_peringatan_dini_hive/helpers/hive_helper.dart';
import 'package:aiot_peringatan_dini_hive/helpers/pengaturan_helper.dart';
import 'package:aiot_peringatan_dini_hive/models/pembacaan_sensor.dart';
import 'package:aiot_peringatan_dini_hive/widgets/form_pembacaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory folder;

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('modul9_navigasi_');
    Hive.init(folder.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }
    HiveHelper.instance.box = await Hive.openBox<PembacaanSensor>(
      'pembacaanSensorBox',
    );
    SharedPreferences.setMockInitialValues({});
    await PengaturanHelper.instance.init();
    await PengaturanHelper.instance.reset();
  });

  tearDown(() async {
    await Hive.close();
    await folder.delete(recursive: true);
  });

  Future<void> buka(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const AiotApp());
    await tester.pumpAndSettle();
  }

  Future<void> tab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
  }

  testWidgets('empat tab mempertahankan draf dan Back kembali ke Sensor', (
    tester,
  ) async {
    await buka(tester);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    await tab(tester, 'Pantauan');
    await tester.enterText(find.byKey(const Key('input_nilai')), '150');
    await tester.enterText(find.byKey(const Key('input_lokasi')), 'Pos Uji');
    await tab(tester, 'Riwayat');
    expect(find.text('Riwayat Sensor'), findsOneWidget);
    await tab(tester, 'Pengaturan');
    expect(find.text('Pengaturan Ambang Batas'), findsOneWidget);
    await tab(tester, 'Pantauan');
    final field = tester.widget<TextFormField>(
      find.byKey(const Key('input_lokasi')),
    );
    expect(field.controller!.text, 'Pos Uji');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Siaga Nusantara'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form Pantauan membersihkan input sesudah callback berhasil', (
    tester,
  ) async {
    PembacaanSensor? tersimpan;
    await tester.pumpWidget(
      MaterialApp(
        home: FormPembacaan(
          sebagaiHalaman: true,
          onSimpan: (data) async {
            tersimpan = data;
            return true;
          },
        ),
      ),
    );
    await tester.enterText(find.byKey(const Key('input_nilai')), '150');
    await tester.enterText(find.byKey(const Key('input_lokasi')), 'Pos Uji');
    await tester.tap(find.text('Simpan Pembacaan'));
    await tester.pumpAndSettle();
    expect(tersimpan!.nilai, 150);
    expect(tersimpan!.lokasiPos, 'Pos Uji');
    expect(find.text('Pantauan Sensor'), findsOneWidget);
    final field = tester.widget<TextFormField>(
      find.byKey(const Key('input_nilai')),
    );
    expect(field.controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
