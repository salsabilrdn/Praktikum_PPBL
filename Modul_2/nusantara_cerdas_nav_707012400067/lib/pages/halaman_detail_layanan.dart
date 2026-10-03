import 'package:flutter/material.dart';

class HalamanDetailLayanan extends StatelessWidget {
  final Map<String, dynamic> layanan;

  const HalamanDetailLayanan({super.key, required this.layanan});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text('Detail Layanan'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KARTU INFORMASI LAYANAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFE8EDF6),
                    child: Icon(
                      layanan['ikon'] ?? Icons.miscellaneous_services,
                      color: biru,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    layanan['nama'] ?? 'Nama Layanan',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Instansi Penanggung Jawab',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    layanan['instansi'] ?? '-',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Divider(height: 28),

                  const Text(
                    'Jam Operasional',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    layanan['jam'] ?? '-',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Divider(height: 28),

                  const Text(
                    'Deskripsi Layanan',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    layanan['detail'] ?? layanan['deskripsi'] ?? '-',
                    style: const TextStyle(
                      color: Color(0xFF475467),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TOMBOL AJUKAN PERMOHONAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final nama = layanan['nama'] ?? 'Layanan';

                  Navigator.pop(context, 'Permohonan $nama telah diajukan.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ajukan Permohonan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
