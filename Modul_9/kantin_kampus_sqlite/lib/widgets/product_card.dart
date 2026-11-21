import 'package:flutter/material.dart';

import '../models/produk.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.produk,
    required this.onTambah,
    required this.onFavorit,
    required this.isFavorit,
  });
  final Produk produk;
  final VoidCallback onTambah, onFavorit;
  final bool isFavorit;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(produk.nama),
      subtitle: Text('Rp${produk.harga}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Favorit ${produk.nama}',
            onPressed: onFavorit,
            icon: Icon(
              isFavorit ? Icons.favorite : Icons.favorite_border,
              color: isFavorit ? Colors.red : null,
            ),
          ),
          IconButton(
            tooltip: 'Tambah ${produk.nama}',
            onPressed: onTambah,
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
    ),
  );
}
