import 'package:flutter/foundation.dart';

class Pengajuan {
  final String nama;
  final String email;
  final String kategori;
  final String sesi;
  bool selesai;

  Pengajuan({
    required this.nama,
    required this.email,
    required this.kategori,
    required this.sesi,
    this.selesai = false,
  });
}

class PengajuanModel extends ChangeNotifier {
  // Keranjang layanan yang belum dikirim.
  final List<String> _keranjang = [];

  // Daftar pengajuan yang sudah dikirim.
  final List<Pengajuan> _pengajuan = [];

  List<String> get keranjang => List.unmodifiable(_keranjang);

  List<Pengajuan> get pengajuan => List.unmodifiable(_pengajuan);

  int get totalKeranjang => _keranjang.length;

  int get totalPengajuan => _pengajuan.length;

  // Menambahkan layanan ke keranjang.
  void tambahKeKeranjang(String namaLayanan) {
    if (!_keranjang.contains(namaLayanan)) {
      _keranjang.add(namaLayanan);
      notifyListeners();
    }
  }

  // Menghapus layanan dari keranjang.
  void hapusDariKeranjang(String namaLayanan) {
    _keranjang.remove(namaLayanan);
    notifyListeners();
  }

  // Mengosongkan keranjang.
  void kosongkanKeranjang() {
    if (_keranjang.isEmpty) return;

    _keranjang.clear();
    notifyListeners();
  }

  // Menambahkan satu pengajuan lengkap.
  void tambahPengajuan(Pengajuan data) {
    _pengajuan.add(data);
    notifyListeners();
  }

  // Mengirim seluruh layanan di keranjang.
  void kirimSemuaPengajuan({
    required String nama,
    required String email,
    required String sesi,
  }) {
    if (_keranjang.isEmpty) return;

    for (final layanan in _keranjang) {
      _pengajuan.add(
        Pengajuan(nama: nama, email: email, kategori: layanan, sesi: sesi),
      );
    }

    _keranjang.clear();
    notifyListeners();
  }

  // Menandai pengajuan selesai ditindaklanjuti.
  void tandaiSelesai(int indeks) {
    if (indeks < 0 || indeks >= _pengajuan.length) return;

    _pengajuan[indeks].selesai = true;
    notifyListeners();
  }

  // Menghitung pengajuan berdasarkan kategori.
  int jumlahKategori(String kategori) {
    return _pengajuan.where((p) => p.kategori == kategori).length;
  }
}
