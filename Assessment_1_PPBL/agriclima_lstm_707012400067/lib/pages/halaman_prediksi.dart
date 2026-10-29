import 'package:flutter/material.dart';

import 'halaman_input_prediksi.dart';

class HalamanPrediksi extends StatelessWidget {
  const HalamanPrediksi({super.key});

  static const pinkGelap = Color(0xFF880E4F);
  static const pinkAksen = Color(0xFFC2185B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediksi Mikrolimat'),
        backgroundColor: pinkGelap,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prediksi Mikroklimat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: pinkGelap,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan hasil prediksi untuk petak tanaman melalui formulir input.',
              style: TextStyle(color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final tersimpan = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HalamanInputPrediksi(),
                    ),
                  );
                  if (tersimpan == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data tersimpan')),
                    );
                  }
                },
                icon: const Icon(Icons.add_chart),
                label: const Text('Input Hasil Prediksi'),
                style: FilledButton.styleFrom(
                  backgroundColor: pinkAksen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _InfoPrediksi(
              ikon: Icons.rule_folder_outlined,
              judul: 'Validasi otomatis',
              deskripsi: 'Nilai kelembapan harus berada di antara 0 sampai 100 persen.',
            ),
            const _InfoPrediksi(
              ikon: Icons.verified_outlined,
              judul: 'Konfirmasi data',
              deskripsi:
                  'Data akan disimpan setelah Anda mengonfirmasi kebenarannya.',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPrediksi extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String deskripsi;

  const _InfoPrediksi({
    required this.ikon,
    required this.judul,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(ikon, color: const Color(0xFFC2185B)),
        title: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(deskripsi),
      ),
    );
  }
}
