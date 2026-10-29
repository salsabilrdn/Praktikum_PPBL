import 'package:flutter/foundation.dart';

class DataPrediksi {
  final String kategori;
  final double nilai;
  final DateTime waktu;
  final int? petak;
  final String? tanaman;
  final String? namaPetugas;
  final String? status;

  const DataPrediksi({
    required this.kategori,
    required this.nilai,
    required this.waktu,
    this.petak,
    this.tanaman,
    this.namaPetugas,
    this.status,
  });
}

class PengajuanModel extends ChangeNotifier {
  final List<DataPrediksi> _pengajuan = [];

  List<DataPrediksi> get pengajuan => List.unmodifiable(_pengajuan);

  void simpanPrediksi({
    required double suhu,
    required double kelembapanUdara,
    required double kelembapanTanah,
  }) {
    final waktu = DateTime.now();
    _pengajuan.addAll([
      DataPrediksi(kategori: 'Suhu udara', nilai: suhu, waktu: waktu),
      DataPrediksi(
        kategori: 'Kelembapan udara',
        nilai: kelembapanUdara,
        waktu: waktu,
      ),
      DataPrediksi(
        kategori: 'Kelembapan tanah',
        nilai: kelembapanTanah,
        waktu: waktu,
      ),
    ]);
    notifyListeners();
  }

  void simpanDataPrediksi({
    required int petak,
    required String tanaman,
    required String namaPetugas,
    required double suhu,
    required double kelembapanUdara,
    required double kelembapanTanah,
    required String status,
  }) {
    final waktu = DateTime.now();
    _pengajuan.addAll([
      DataPrediksi(
        kategori: 'Suhu udara',
        nilai: suhu,
        waktu: waktu,
        petak: petak,
        tanaman: tanaman,
        namaPetugas: namaPetugas,
        status: status,
      ),
      DataPrediksi(
        kategori: 'Kelembapan udara',
        nilai: kelembapanUdara,
        waktu: waktu,
        petak: petak,
        tanaman: tanaman,
        namaPetugas: namaPetugas,
        status: status,
      ),
      DataPrediksi(
        kategori: 'Kelembapan tanah',
        nilai: kelembapanTanah,
        waktu: waktu,
        petak: petak,
        tanaman: tanaman,
        namaPetugas: namaPetugas,
        status: status,
      ),
    ]);
    notifyListeners();
  }
}
