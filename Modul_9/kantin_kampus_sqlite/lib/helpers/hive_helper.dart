import 'package:hive_flutter/hive_flutter.dart';

import '../models/produk_favorit.dart';

class HiveHelper {
  HiveHelper._();
  static final instance = HiveHelper._();
  late Box<ProdukFavorit> box;
  Future<void> init() async {
    await Hive.initFlutter('kantin_modul9');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProdukFavoritAdapter());
    }
    box = await Hive.openBox<ProdukFavorit>('favoritBox');
  }

  Future<void> simpan(ProdukFavorit item) async {
    if (!box.containsKey(item.idProduk)) await box.put(item.idProduk, item);
  }

  Future<void> ubahCatatan(ProdukFavorit item, String catatan) async {
    final lama = item.catatan;
    item.catatan = catatan.trim();
    try {
      await item.save();
    } catch (_) {
      item.catatan = lama;
      rethrow;
    }
  }

  Future<void> hapus(ProdukFavorit item) => item.delete();
}
