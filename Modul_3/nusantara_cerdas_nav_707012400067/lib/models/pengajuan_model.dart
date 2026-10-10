import 'package:flutter/foundation.dart';

class PengajuanModel extends ChangeNotifier {
  // Layanan yang dipilih, tetapi belum dikirim.
  final List<String> _keranjang = [];

  // Layanan yang sudah dikirim.
  final List<String> _pengajuan = [];

  List<String> get keranjang => List.unmodifiable(_keranjang);

  List<String> get pengajuan => List.unmodifiable(_pengajuan);

  int get totalKeranjang => _keranjang.length;

  int get totalPengajuan => _pengajuan.length;

  // Menambahkan layanan ke keranjang.
  void tambahKeKeranjang(String namaLayanan) {
    if (!_keranjang.contains(namaLayanan)) {
      _keranjang.add(namaLayanan);
      notifyListeners();
    }
  }

  // Menghapus satu layanan dari keranjang.
  void hapusDariKeranjang(String namaLayanan) {
    _keranjang.remove(namaLayanan);
    notifyListeners();
  }

  // Mengirim semua layanan dalam keranjang sekaligus.
  void kirimSemuaPengajuan() {
    if (_keranjang.isEmpty) return;

    _pengajuan.addAll(_keranjang);
    _keranjang.clear();

    notifyListeners();
  }

  // Mengosongkan keranjang.
  void kosongkanKeranjang() {
    if (_keranjang.isEmpty) return;

    _keranjang.clear();
    notifyListeners();
  }
}
