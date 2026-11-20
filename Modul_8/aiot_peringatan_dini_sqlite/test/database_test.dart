import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:aiot_peringatan_dini_sqlite/cubit/sensor_cubit.dart';
import 'package:aiot_peringatan_dini_sqlite/db/database_helper.dart';
import 'package:aiot_peringatan_dini_sqlite/models/pembacaan_sensor.dart';
import 'package:aiot_peringatan_dini_sqlite/models/status_siaga.dart';

void main() {
  sqfliteFfiInit();
  late Directory folder;
  late DatabaseHelper helper;
  late String path;
  final waktu = DateTime.utc(2026, 11, 20, 8);
  PembacaanSensor data(JenisSensor jenis, double nilai, int menit) =>
      PembacaanSensor(
        jenisSensor: jenis,
        nilai: nilai,
        lokasiPos: 'Pos $menit',
        waktu: waktu.add(Duration(minutes: menit)),
      );

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('aiot_db_test_');
    path = p.join(folder.path, 'test.db');
    helper = DatabaseHelper.untukPengujian(databaseFactoryFfiNoIsolate, path);
  });
  tearDown(() async {
    await helper.tutup();
    await folder.delete(recursive: true);
  });

  test(
    'Koneksi yang dibuka bersamaan menggunakan database yang sama',
    () async {
      final hasil = await Future.wait([helper.database, helper.database]);
      expect(identical(hasil[0], hasil[1]), isTrue);
      expect(
        identical(DatabaseHelper.instance, DatabaseHelper.instance),
        isTrue,
      );
    },
  );
  test('CRUD menarget satu ID dan bertahan setelah koneksi ditutup', () async {
    final air = await helper.tambahPembacaan(
      data(JenisSensor.ketinggianAir, 80.5, 0),
    );
    final hujan = await helper.tambahPembacaan(
      data(JenisSensor.curahHujan, 60, 1),
    );
    final tanah = await helper.tambahPembacaan(
      data(JenisSensor.pergeseranTanah, 12, 2),
    );
    var semua = await helper.ambilSemuaPembacaan();
    expect(semua.map((x) => x.id), [tanah, hujan, air]);
    expect(StatusSiaga.dariPembacaan(semua), StatusSiaga.siaga);
    expect(await helper.ubahNilai(tanah, 4), 1);
    semua = await helper.ambilSemuaPembacaan();
    expect(semua.first.nilai, 4);
    expect(semua.first.waktu, waktu.add(const Duration(minutes: 2)));
    expect(semua.singleWhere((x) => x.id == air).nilai, 80.5);
    expect(semua.singleWhere((x) => x.id == hujan).nilai, 60);
    expect(StatusSiaga.dariPembacaan(semua), StatusSiaga.waspada);
    expect(await helper.hapusPembacaan(hujan), 1);
    expect(await helper.hapusPembacaan(99999), 0);
    await helper.tutup();
    helper = DatabaseHelper.untukPengujian(databaseFactoryFfiNoIsolate, path);
    semua = await helper.ambilSemuaPembacaan();
    expect(semua.map((x) => x.id), [tanah, air]);
    expect(semua.map((x) => x.nilai), [4, 80.5]);
    expect(StatusSiaga.dariPembacaan(semua), StatusSiaga.aman);
  });
  test(
    'Status memakai data terbaru per jenis, termasuk waktu yang sama',
    () async {
      await helper.tambahPembacaan(data(JenisSensor.ketinggianAir, 250, 0));
      await helper.tambahPembacaan(data(JenisSensor.ketinggianAir, 120, 1));
      final terakhir = await helper.tambahPembacaan(
        data(JenisSensor.ketinggianAir, 80, 1),
      );
      await helper.tambahPembacaan(data(JenisSensor.curahHujan, 60, 0));
      final terbaru = await helper.ambilPembacaanTerbaru();
      expect(terbaru, hasLength(2));
      expect(
        terbaru
            .singleWhere((x) => x.jenisSensor == JenisSensor.ketinggianAir)
            .id,
        terakhir,
      );
      expect(
        StatusSiaga.dariPembacaan(await helper.ambilSemuaPembacaan()),
        StatusSiaga.waspada,
      );
    },
  );
  test('Batas status dan kondisi database kosong', () {
    expect(StatusSiaga.dariPembacaan([]), StatusSiaga.belumAdaData);
    for (final jenis in JenisSensor.values) {
      expect(
        StatusSiaga.untuk(data(jenis, jenis.batasWaspada - 0.1, 0)),
        StatusSiaga.aman,
      );
      expect(
        StatusSiaga.untuk(data(jenis, jenis.batasWaspada, 0)),
        StatusSiaga.waspada,
      );
      expect(
        StatusSiaga.untuk(data(jenis, jenis.batasSiaga, 0)),
        StatusSiaga.siaga,
      );
    }
  });
  test('Nilai negatif, NaN, tak hingga, dan lokasi kosong ditolak', () async {
    for (final nilai in [-1.0, double.nan, double.infinity]) {
      await expectLater(
        helper.tambahPembacaan(data(JenisSensor.curahHujan, nilai, 0)),
        throwsArgumentError,
      );
      await expectLater(helper.ubahNilai(1, nilai), throwsArgumentError);
    }
    await expectLater(
      helper.tambahPembacaan(
        PembacaanSensor(
          jenisSensor: JenisSensor.curahHujan,
          nilai: 1,
          lokasiPos: '   ',
          waktu: waktu,
        ),
      ),
      throwsArgumentError,
    );
    expect(await helper.jumlahPembacaan(), 0);
  });
  test('Gagal insert tidak membuat pembacaan semu di Cubit', () async {
    final db = await helper.database;
    await db.execute(
      "CREATE TRIGGER gagal BEFORE INSERT ON pembacaan_sensor BEGIN SELECT RAISE(ABORT, 'uji gagal'); END",
    );
    final cubit = SensorCubit(helper);
    try {
      expect(await cubit.tambah(data(JenisSensor.curahHujan, 60, 0)), isFalse);
      expect(cubit.state.terbaru, isEmpty);
      expect(cubit.state.sibuk, isFalse);
      expect(cubit.state.error, isNotNull);
      expect(await helper.jumlahPembacaan(), 0);
    } finally {
      await cubit.close();
    }
  });
}
