import 'package:hive/hive.dart';
part 'produk_favorit.g.dart';

@HiveType(typeId: 0)
class ProdukFavorit extends HiveObject {
  @HiveField(0)
  final String idProduk;
  @HiveField(1)
  final String nama;
  @HiveField(2)
  final int harga;
  @HiveField(3)
  String catatan;
  ProdukFavorit({
    required this.idProduk,
    required this.nama,
    required this.harga,
    this.catatan = '',
  });
}
