import 'package:flutter/material.dart';

import '../models/pengajuan_model.dart';

class DetailPengajuan extends StatelessWidget {
  final Pengajuan pengajuan;

  const DetailPengajuan({super.key, required this.pengajuan});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Detail Pengajuan'),
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
                  const Icon(Icons.description_outlined, size: 48, color: biru),
                  const SizedBox(height: 12),
                  const Text(
                    'Informasi Pengajuan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _itemDetail('Nama Pemohon', pengajuan.nama),
                  _itemDetail('Email', pengajuan.email),
                  _itemDetail('Kategori Layanan', pengajuan.kategori),
                  _itemDetail('Sesi Layanan', pengajuan.sesi),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  const Text(
                    'Status Pengajuan',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: pengajuan.selesai
                          ? const Color(0xFFDDF5E5)
                          : const Color(0xFFFFF0D6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pengajuan.selesai ? 'Selesai' : 'Dalam proses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pengajuan.selesai
                            ? Colors.green.shade800
                            : Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDetail(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            isi,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}
