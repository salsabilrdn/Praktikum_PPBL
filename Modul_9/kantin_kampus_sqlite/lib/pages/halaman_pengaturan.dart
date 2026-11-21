import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';
import '../helpers/pengaturan_helper.dart';

class HalamanPengaturan extends StatefulWidget {
  const HalamanPengaturan({super.key});
  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  late final TextEditingController nama;
  bool sibuk = false;
  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: PengaturanHelper.instance.namaPelanggan);
  }

  @override
  void dispose() {
    nama.dispose();
    super.dispose();
  }

  Future<void> aksi(Future<void> Function() operasi, String pesan) async {
    if (sibuk) return;
    setState(() {
      sibuk = true;
    });
    try {
      await operasi();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesan)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan belum tersimpan.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          sibuk = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan Kantin')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: nama,
          maxLength: 80,
          decoration: const InputDecoration(
            labelText: 'Nama pelanggan',
            border: OutlineInputBorder(),
          ),
        ),
        FilledButton(
          onPressed: sibuk
              ? null
              : () => aksi(
                  () => PengaturanHelper.instance.simpanNama(nama.text),
                  'Nama pelanggan tersimpan.',
                ),
          child: const Text('Simpan Nama'),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Tema Gelap'),
          value: context.watch<ThemeCubit>().state == ThemeMode.dark,
          onChanged: sibuk
              ? null
              : (nilai) => aksi(
                  () => context.read<ThemeCubit>().ubah(nilai),
                  'Tema tersimpan.',
                ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: sibuk
              ? null
              : () => aksi(() async {
                  await context.read<ThemeCubit>().reset();
                  nama.clear();
                }, 'Pengaturan direset; favorit dan pesanan tetap tersimpan.'),
          child: const Text('Reset Pengaturan'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nama dan tema: SharedPreferences. Favorit: Hive. Riwayat pesanan: SQLite.',
        ),
      ],
    ),
  );
}
