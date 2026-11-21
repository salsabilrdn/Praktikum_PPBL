import 'package:hive_flutter/hive_flutter.dart';

import '../models/pembacaan_sensor.dart';

class HiveHelper {
  HiveHelper._();
  static final instance = HiveHelper._();
  late Box<PembacaanSensor> box;
  Future<void> init() async {
    await Hive.initFlutter('aiot_modul9');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }
    box = await Hive.openBox<PembacaanSensor>('pembacaanSensorBox');
  }

  List<PembacaanSensor> get riwayat => box.values.toList()
    ..sort((a, b) {
      final urut = b.waktu.compareTo(a.waktu);
      return urut != 0 ? urut : b.id.compareTo(a.id);
    });
  Future<List<PembacaanSensor>> ambilSemuaPembacaan() async => riwayat;
  Future<List<PembacaanSensor>> ambilPembacaanTerbaru() async {
    final jenis = <JenisSensor>{};
    return riwayat.where((p) => jenis.add(p.jenisSensor)).toList();
  }

  Future<int> jumlahPembacaan() async => box.length;
  Future<String> tambahPembacaan(PembacaanSensor data) async {
    if (!data.nilai.isFinite ||
        data.nilai < 0 ||
        data.lokasiPos.trim().isEmpty) {
      throw ArgumentError('Data sensor tidak valid.');
    }
    if (box.containsKey(data.id)) throw StateError('ID sudah digunakan.');
    await box.put(data.id, data);
    return data.id;
  }

  Future<int> ubahNilai(String id, double nilai) async {
    if (!nilai.isFinite || nilai < 0) throw ArgumentError('Nilai tidak valid.');
    final data = box.get(id);
    if (data == null) return 0;
    final lama = data.nilai;
    data.nilai = nilai;
    try {
      await data.save();
    } catch (_) {
      data.nilai = lama;
      rethrow;
    }
    return 1;
  }

  Future<int> hapusPembacaan(String id) async {
    final data = box.get(id);
    if (data == null) return 0;
    await data.delete();
    return 1;
  }
}
