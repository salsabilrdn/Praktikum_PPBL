import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pembacaan_sensor.dart';

class BatasSensor {
  const BatasSensor(this.waspada, this.siaga);
  final double waspada, siaga;
  bool get valid =>
      waspada.isFinite && siaga.isFinite && waspada >= 0 && siaga > waspada;
}

class PengaturanHelper {
  PengaturanHelper._();
  static final instance = PengaturanHelper._();
  late SharedPreferences prefs;
  final ambang = ValueNotifier<Map<JenisSensor, BatasSensor>>({
    for (final jenis in JenisSensor.values)
      jenis: BatasSensor(jenis.batasWaspada, jenis.batasSiaga),
  });
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('ambang_batas_v1');
    if (saved == null) return;
    try {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      final hasil = {
        for (final jenis in JenisSensor.values)
          jenis: BatasSensor(
            (data[jenis.kode]['waspada'] as num).toDouble(),
            (data[jenis.kode]['siaga'] as num).toDouble(),
          ),
      };
      if (hasil.values.every((b) => b.valid)) {
        ambang.value = Map.unmodifiable(hasil);
      }
    } catch (_) {
      /* Gunakan nilai awal jika preferensi rusak. */
    }
  }

  Future<void> simpanAmbang(Map<JenisSensor, BatasSensor> data) async {
    if (data.length != 3 ||
        !JenisSensor.values.every(data.containsKey) ||
        !data.values.every((b) => b.valid)) {
      throw ArgumentError('Ambang tidak valid.');
    }
    final json = jsonEncode({
      for (final e in data.entries)
        e.key.kode: {'waspada': e.value.waspada, 'siaga': e.value.siaga},
    });
    if (!await prefs.setString('ambang_batas_v1', json)) {
      throw StateError('Ambang belum tersimpan.');
    }
    ambang.value = Map.unmodifiable(data);
  }

  Future<void> reset() async {
    if (!await prefs.remove('ambang_batas_v1')) {
      throw StateError('Ambang belum direset.');
    }
    ambang.value = {
      for (final j in JenisSensor.values)
        j: BatasSensor(j.batasWaspada, j.batasSiaga),
    };
  }
}
