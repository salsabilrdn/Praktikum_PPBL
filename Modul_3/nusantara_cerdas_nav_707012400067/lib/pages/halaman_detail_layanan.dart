import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class HalamanDetailLayanan extends StatefulWidget {
  final Map<String, dynamic> layanan;

  const HalamanDetailLayanan({super.key, required this.layanan});

  @override
  State<HalamanDetailLayanan> createState() => _HalamanDetailLayananState();
}

class _HalamanDetailLayananState extends State<HalamanDetailLayanan> {
  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  bool sedangMenambahkan = false;

  Future<void> tambahKeKeranjang() async {
    if (sedangMenambahkan) return;

    setState(() {
      sedangMenambahkan = true;
    });

    // Simulasi proses penambahan layanan.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final nama = (widget.layanan['nama'] ?? 'Layanan').toString();

    final model = context.read<PengajuanModel>();

    if (model.keranjang.contains(nama)) {
      Navigator.pop(context, '$nama sudah ada di keranjang.');
      return;
    }

    model.tambahKeKeranjang(nama);

    Navigator.pop(context, '$nama berhasil ditambahkan ke keranjang.');
  }

  @override
  Widget build(BuildContext context) {
    final nama = (widget.layanan['nama'] ?? 'Nama Layanan').toString();

    final ikon = widget.layanan['ikon'];

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
                      ikon is IconData ? ikon : Icons.miscellaneous_services,
                      color: biru,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    nama,
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
                    (widget.layanan['instansi'] ?? '-').toString(),
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
                    (widget.layanan['jam'] ?? '-').toString(),
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
                    (widget.layanan['detail'] ??
                            widget.layanan['deskripsi'] ??
                            '-')
                        .toString(),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: sedangMenambahkan ? null : tambahKeKeranjang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF8B9BB5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: sedangMenambahkan
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Menambahkan ke keranjang...'),
                        ],
                      )
                    : const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
