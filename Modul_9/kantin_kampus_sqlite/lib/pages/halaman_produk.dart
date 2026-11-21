import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../cubit/keranjang_cubit.dart';
import '../helpers/hive_helper.dart';
import '../models/produk.dart';
import '../models/produk_favorit.dart';
import '../widgets/product_card.dart';
import '../widgets/theme_toggle_button.dart';

class HalamanProduk extends StatelessWidget {
  const HalamanProduk({super.key});
  static const daftarProduk = [
    Produk(id: 'p1', nama: 'Nasi Goreng', harga: 15000),
    Produk(id: 'p2', nama: 'Es Teh Manis', harga: 5000),
    Produk(id: 'p3', nama: 'Ayam Geprek', harga: 18000),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Produk Kantin'),
      actions: const [ThemeToggleButton()],
    ),
    body: ValueListenableBuilder<Box<ProdukFavorit>>(
      valueListenable: HiveHelper.instance.box.listenable(),
      builder: (context, box, _) => ListView.builder(
        itemCount: daftarProduk.length,
        itemBuilder: (context, index) {
          final produk = daftarProduk[index];
          return ProductCard(
            produk: produk,
            isFavorit: box.containsKey(produk.id),
            onTambah: () => context.read<KeranjangCubit>().tambah(produk),
            onFavorit: () async {
              try {
                await HiveHelper.instance.simpan(
                  ProdukFavorit(
                    idProduk: produk.id,
                    nama: produk.nama,
                    harga: produk.harga,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk tersimpan di favorit.'),
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Favorit belum tersimpan.')),
                  );
                }
              }
            },
          );
        },
      ),
    ),
  );
}
