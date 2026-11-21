import 'package:shared_preferences/shared_preferences.dart';

class PengaturanHelper {
  PengaturanHelper._();
  static final instance = PengaturanHelper._();
  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get temaGelap => prefs.getBool('tema_gelap') ?? false;
  String get namaPelanggan => prefs.getString('nama_pelanggan') ?? '';
  Future<void> simpanTema(bool aktif) async {
    if (!await prefs.setBool('tema_gelap', aktif)) {
      throw StateError('Tema belum tersimpan.');
    }
  }

  Future<void> simpanNama(String nama) async {
    if (!await prefs.setString('nama_pelanggan', nama.trim())) {
      throw StateError('Nama belum tersimpan.');
    }
  }

  Future<void> resetSemua() async {
    await prefs.remove('tema_gelap');
    await prefs.remove('nama_pelanggan');
  }
}
