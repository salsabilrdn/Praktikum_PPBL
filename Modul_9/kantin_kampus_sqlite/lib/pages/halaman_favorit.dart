import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../helpers/hive_helper.dart';
import '../models/produk_favorit.dart';

class HalamanFavorit extends StatelessWidget {
  const HalamanFavorit({super.key});
  Future<void> _edit(BuildContext context, ProdukFavorit item) async {
    final nilai = await showDialog<String>(
      context: context,
      builder: (_) => DialogCatatan(item: item),
    );
    if (nilai == null) return;
    try {
      await HiveHelper.instance.ubahCatatan(item, nilai);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan belum tersimpan.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Produk Favorit')),
    body: ValueListenableBuilder<Box<ProdukFavorit>>(
      valueListenable: HiveHelper.instance.box.listenable(),
      builder: (context, box, _) {
        final daftar = box.values.toList();
        if (daftar.isEmpty) {
          return const Center(child: Text('Belum ada produk favorit.'));
        }
        return ListView.builder(
          itemCount: daftar.length,
          itemBuilder: (context, index) {
            final item = daftar[index];
            return Dismissible(
              key: ValueKey(item.idProduk),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) async {
                try {
                  await HiveHelper.instance.hapus(item);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favorit belum terhapus.')),
                    );
                  }
                }
                return false;
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                child: ListTile(
                  title: Text(item.nama),
                  subtitle: Text(
                    'Rp${item.harga}\n${item.catatan.isEmpty ? "Belum ada catatan" : item.catatan}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Ubah catatan ${item.nama}',
                    onPressed: () => _edit(context, item),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  onTap: () => _edit(context, item),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

class DialogCatatan extends StatefulWidget {
  const DialogCatatan({super.key, required this.item});
  final ProdukFavorit item;
  @override
  State<DialogCatatan> createState() => _DialogCatatanState();
}

class _DialogCatatanState extends State<DialogCatatan> {
  late final TextEditingController teks;
  @override
  void initState() {
    super.initState();
    teks = TextEditingController(text: widget.item.catatan);
  }

  @override
  void dispose() {
    teks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Ubah Catatan'),
    content: TextField(
      controller: teks,
      maxLength: 150,
      decoration: const InputDecoration(labelText: 'Catatan favorit'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, teks.text.trim()),
        child: const Text('Simpan Catatan'),
      ),
    ],
  );
}
