import 'package:flutter/material.dart';

import 'kepala_kota.dart';
import 'kartu_pilar.dart';
import 'panel_laporan.dart';

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),

      appBar: AppBar(
        title: const Text('Nusantara Cerdas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITAS KOTA
            const KepalaKota(),

            const SizedBox(height: 24),

            // PILAR SMART CITY
            const Text(
              'Pilar Smart City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // BARIS 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KartuPilar(
                  namaPilar: 'Smart Governance',
                  ikon: Icons.account_balance,
                  warna: Colors.blue,
                  deskripsi:
                      'Pelayanan publik lebih transparan dan efektif.',
                ),

                const SizedBox(width: 10),

                KartuPilar(
                  namaPilar: 'Smart Economy',
                  ikon: Icons.bar_chart,
                  warna: Colors.green,
                  deskripsi:
                      'Ekonomi daerah tumbuh melalui inovasi digital.',
                ),
              ],
            ),

            const SizedBox(height: 10),

            // BARIS 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KartuPilar(
                  namaPilar: 'Smart Living',
                  ikon: Icons.groups,
                  warna: Colors.pink,
                  deskripsi:
                      'Kehidupan warga lebih sehat, aman, dan nyaman.',
                ),

                const SizedBox(width: 10),

                KartuPilar(
                  namaPilar: 'Smart Mobility',
                  ikon: Icons.directions_bus,
                  warna: Colors.orange,
                  deskripsi:
                      'Mobilitas lebih mudah dengan transportasi terintegrasi.',
                ),
              ],
            ),

            const SizedBox(height: 10),

            // BARIS 3
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KartuPilar(
                  namaPilar: 'Smart Environment',
                  ikon: Icons.eco,
                  warna: Colors.teal,
                  deskripsi:
                      'Lingkungan kota lebih bersih dan berkelanjutan.',
                ),

                const SizedBox(width: 10),

                KartuPilar(
                  namaPilar: 'Smart People',
                  ikon: Icons.people,
                  warna: Colors.deepPurple,
                  deskripsi:
                      'Masyarakat cerdas dan berdaya saing di era digital.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // LAPORAN WARGA
            const Text(
              'Laporan Warga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const PanelLaporanWarga(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}