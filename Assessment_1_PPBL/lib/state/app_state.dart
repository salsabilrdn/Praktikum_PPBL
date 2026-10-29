import 'dart:math';

import 'package:flutter/foundation.dart';

class PrediksiData {
  const PrediksiData({
    required this.petak,
    required this.tanaman,
    required this.suhu,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.petugas,
    required this.status,
    required this.catatan,
    required this.waktu,
  });

  final int petak;
  final String tanaman;
  final double suhu;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String petugas;
  final String status;
  final String catatan;
  final DateTime waktu;
}

class AppState extends ChangeNotifier {
  final List<PrediksiData> _prediksi = [];
  bool _modeGelap = false;

  List<PrediksiData> get prediksi => List.unmodifiable(_prediksi);
  bool get modeGelap => _modeGelap;

  void ubahModeGelap(bool aktif) {
    _modeGelap = aktif;
    notifyListeners();
  }

  void tambahPrediksi(PrediksiData data) {
    _prediksi.insert(0, data);
    notifyListeners();
  }

  void muatDataSimulasi() {
    final random = Random();
    _prediksi
      ..clear()
      ..addAll(
        List.generate(10, (index) {
          final kelembapanTanah = 20 + random.nextInt(71);
          final tanaman = ['Padi', 'Jagung', 'Cabai'][random.nextInt(3)];
          final status = tentukanStatus(kelembapanTanah.toDouble());
          return PrediksiData(
            petak: 1 + random.nextInt(2),
            tanaman: tanaman,
            suhu: 18 + random.nextInt(18).toDouble(),
            kelembapanUdara: 40 + random.nextInt(61).toDouble(),
            kelembapanTanah: kelembapanTanah.toDouble(),
            petugas: 'Data Simulasi',
            status: status,
            catatan: catatanPerawatan(tanaman),
            waktu: DateTime.now().subtract(Duration(hours: index)),
          );
        }),
      );
    notifyListeners();
  }

  void hapusSemuaPrediksi() {
    _prediksi.clear();
    notifyListeners();
  }

  static String tentukanStatus(double kelembapanTanah) {
    if (kelembapanTanah < 40) return 'Kering';
    if (kelembapanTanah <= 70) return 'Optimal';
    return 'Terlalu lembap';
  }

  static String catatanPerawatan(String tanaman) {
    switch (tanaman) {
      case 'Padi':
        return 'Jaga genangan air 2-5 cm pada fase vegetatif dan keringkan '
            'lahan menjelang panen.';
      case 'Jagung':
        return 'Siram saat tanah mulai kering dan hindari genangan di sekitar '
            'perakaran.';
      case 'Cabai':
        return 'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada '
            'pagi atau sore hari.';
      default:
        return 'Sesuaikan perawatan dengan kondisi mikroklimat tanaman.';
    }
  }
}
