import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kantin_kampus_sqlite/models/produk_favorit.dart';
import 'package:kantin_kampus_sqlite/helpers/hive_helper.dart';
import 'package:kantin_kampus_sqlite/helpers/pengaturan_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Favorit, catatan, nama, tema, reset, dan persistensi', () async {
    final folder = await Directory.systemTemp.createTemp('modul9_kantin_');
    Hive.init(folder.path);
    Hive.registerAdapter(ProdukFavoritAdapter());
    final h = HiveHelper.instance, p = PengaturanHelper.instance;
    try {
      h.box = await Hive.openBox<ProdukFavorit>('favoritBox');
      SharedPreferences.setMockInitialValues({});
      await p.init();
      await h.simpan(
        ProdukFavorit(idProduk: 'p1', nama: 'Nasi Goreng', harga: 15000),
      );
      await h.ubahCatatan(h.box.get('p1')!, 'Tidak pedas');
      await h.simpan(
        ProdukFavorit(idProduk: 'p1', nama: 'Nasi Goreng', harga: 15000),
      );
      expect(h.box.length, 1);
      expect(h.box.get('p1')!.catatan, 'Tidak pedas');
      await p.simpanNama('Salsabila');
      await p.simpanTema(true);
      await h.box.close();
      h.box = await Hive.openBox<ProdukFavorit>('favoritBox');
      await p.init();
      expect(p.namaPelanggan, 'Salsabila');
      expect(p.temaGelap, isTrue);
      expect(h.box.get('p1')!.catatan, 'Tidak pedas');
      await p.resetSemua();
      expect(p.temaGelap, isFalse);
      expect(p.namaPelanggan, '');
      expect(h.box.length, 1);
      await h.hapus(h.box.get('p1')!);
      expect(h.box.isEmpty, isTrue);
    } finally {
      await Hive.close();
      await folder.delete(recursive: true);
    }
  });
}
