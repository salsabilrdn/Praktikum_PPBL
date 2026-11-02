import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color background = Color(0xFFF4F6FA);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: navy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.location_city,
                color: Colors.white,
                size: 55,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Nusantara Cerdas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Mobile Application',
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Nusantara Cerdas Mobile merupakan aplikasi '
                    'yang dirancang untuk membantu masyarakat '
                    'mengakses informasi dan layanan kota secara '
                    'digital dalam mendukung konsep Smart City.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Utama',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),

                  SizedBox(height: 16),

                  _FiturItem(
                    ikon: Icons.dashboard_outlined,
                    judul: 'Dashboard Smart City',
                    deskripsi: 'Informasi enam pilar Smart City.',
                  ),

                  _FiturItem(
                    ikon: Icons.miscellaneous_services_outlined,
                    judul: 'Layanan Kota',
                    deskripsi:
                        'Informasi perizinan, kesehatan, dan transportasi.',
                  ),

                  _FiturItem(
                    ikon: Icons.person_outline,
                    judul: 'Profil Warga',
                    deskripsi: 'Informasi identitas dan riwayat laporan.',
                  ),

                  _FiturItem(
                    ikon: Icons.settings_outlined,
                    judul: 'Pengaturan',
                    deskripsi: 'Pengaturan preferensi aplikasi.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'Versi Aplikasi 1.0.0',
              style: TextStyle(
                fontSize: 13,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Dikembangkan untuk mendukung Smart City.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FiturItem extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String deskripsi;

  const _FiturItem({
    required this.ikon,
    required this.judul,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: colors.primary, size: 25),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  deskripsi,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
