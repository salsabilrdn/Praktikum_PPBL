import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../db/database_helper.dart';
import '../models/pembacaan_sensor.dart';

class SensorState {
  const SensorState({
    this.terbaru = const [],
    this.jumlah = 0,
    this.sibuk = false,
    this.error,
  });
  final List<PembacaanSensor> terbaru;
  final int jumlah;
  final bool sibuk;
  final String? error;
}

class SensorCubit extends Cubit<SensorState> {
  SensorCubit(this.db) : super(const SensorState());
  final DatabaseHelper db;
  Future<void> muatDashboard() async {
    try {
      final terbaru = await db.ambilPembacaanTerbaru();
      final jumlah = await db.jumlahPembacaan();
      if (!isClosed) emit(SensorState(terbaru: terbaru, jumlah: jumlah));
    } catch (_) {
      if (!isClosed) {
        emit(
          SensorState(
            terbaru: state.terbaru,
            jumlah: state.jumlah,
            error: 'Data belum berhasil dibaca. Silakan muat ulang.',
          ),
        );
      }
    }
  }

  Future<bool> _tulis(Future<void> Function() operasi) async {
    if (state.sibuk) return false;
    emit(
      SensorState(terbaru: state.terbaru, jumlah: state.jumlah, sibuk: true),
    );
    try {
      await operasi();
      await muatDashboard();
      return true;
    } catch (_) {
      if (!isClosed) {
        emit(
          SensorState(
            terbaru: state.terbaru,
            jumlah: state.jumlah,
            error: 'Perubahan belum tersimpan. Silakan coba lagi.',
          ),
        );
      }
      return false;
    }
  }

  Future<bool> tambah(PembacaanSensor data) => _tulis(() async {
    await db.tambahPembacaan(data);
  });
  Future<bool> koreksi(int id, double nilai) => _tulis(() async {
    if (await db.ubahNilai(id, nilai) != 1) {
      throw StateError('ID tidak ditemukan.');
    }
  });
  Future<bool> hapus(int id) => _tulis(() async {
    if (await db.hapusPembacaan(id) != 1) {
      throw StateError('ID tidak ditemukan.');
    }
  });
  Future<bool> simulasikan() {
    final acak = Random();
    final jenis = JenisSensor.values[acak.nextInt(JenisSensor.values.length)];
    final nilai =
        (acak.nextDouble() * jenis.batasSiaga * 1.2 * 10).round() / 10;
    return tambah(
      PembacaanSensor(
        jenisSensor: jenis,
        nilai: nilai,
        lokasiPos: 'Pos Simulasi ${acak.nextInt(3) + 1}',
        waktu: DateTime.now().toUtc(),
      ),
    );
  }
}
