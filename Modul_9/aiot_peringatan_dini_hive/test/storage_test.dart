import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiot_peringatan_dini_hive/helpers/hive_helper.dart';
import 'package:aiot_peringatan_dini_hive/helpers/pengaturan_helper.dart';
import 'package:aiot_peringatan_dini_hive/models/pembacaan_sensor.dart';
import 'package:aiot_peringatan_dini_hive/models/status_siaga.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory folder;
  final h = HiveHelper.instance, p = PengaturanHelper.instance;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('modul9_aiot_');
    Hive.init(folder.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }
    h.box = await Hive.openBox<PembacaanSensor>('pembacaanSensorBox');
    SharedPreferences.setMockInitialValues({});
    await p.init();
    await p.reset();
  });
  tearDown(() async {
    await Hive.close();
    await folder.delete(recursive: true);
  });
  PembacaanSensor data(JenisSensor j, double n, int menit) => PembacaanSensor(
    jenisSensor: j,
    nilai: n,
    lokasiPos: j.label,
    waktu: DateTime.utc(2026, 11, 21, 8, menit),
  );

  test('CRUD per UUID, adapter, urutan, dan buka ulang Hive', () async {
    final air = data(JenisSensor.ketinggianAir, 80, 0),
        hujan = data(JenisSensor.curahHujan, 60, 1),
        tanah = data(JenisSensor.pergeseranTanah, 12, 2);
    for (final x in [air, hujan, tanah]) {
      await h.tambahPembacaan(x);
    }
    expect(h.riwayat.map((x) => x.id), [tanah.id, hujan.id, air.id]);
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.siaga);
    await h.ubahNilai(tanah.id, 4);
    expect(h.box.get(air.id)!.nilai, 80);
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.waspada);
    await h.hapusPembacaan(hujan.id);
    await h.box.close();
    h.box = await Hive.openBox<PembacaanSensor>('pembacaanSensorBox');
    expect(h.riwayat.map((x) => x.nilai), [4, 80]);
    expect(h.box.get(tanah.id)!.lokasiPos, tanah.lokasiPos);
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.aman);
  });
  test('Ambang persisten mengubah status tanpa mengubah riwayat', () async {
    await h.tambahPembacaan(data(JenisSensor.ketinggianAir, 150, 0));
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.waspada);
    await p.simpanAmbang({
      ...p.ambang.value,
      JenisSensor.ketinggianAir: const BatasSensor(160, 220),
    });
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.aman);
    await p.init();
    expect(p.ambang.value[JenisSensor.ketinggianAir]!.waspada, 160);
    expect(h.box.length, 1);
    await expectLater(
      p.simpanAmbang({
        ...p.ambang.value,
        JenisSensor.ketinggianAir: const BatasSensor(220, 160),
      }),
      throwsArgumentError,
    );
    expect(p.ambang.value[JenisSensor.ketinggianAir]!.waspada, 160);
    await p.reset();
    expect(h.box.length, 1);
    expect(StatusSiaga.dariPembacaan(h.riwayat), StatusSiaga.waspada);
  });
  test('ID duplikat dan nilai tidak valid ditolak', () async {
    final x = data(JenisSensor.curahHujan, 20, 0);
    await h.tambahPembacaan(x);
    await expectLater(h.tambahPembacaan(x), throwsStateError);
    for (final nilai in [-1.0, double.nan, double.infinity]) {
      await expectLater(h.ubahNilai(x.id, nilai), throwsArgumentError);
    }
    expect(h.box.get(x.id)!.nilai, 20);
  });
}
