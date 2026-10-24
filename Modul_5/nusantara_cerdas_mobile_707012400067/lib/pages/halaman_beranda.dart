import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);
  static const Color background = Color(0xFFF4F6FA);

  final List<Map<String, dynamic>> daftarPilar = const [
    {
      'nama': 'Smart Governance',
      'deskripsi': 'Pelayanan pemerintahan digital',
      'ikon': Icons.account_balance_outlined,
    },
    {
      'nama': 'Smart Economy',
      'deskripsi': 'Pengembangan ekonomi digital',
      'ikon': Icons.trending_up,
    },
    {
      'nama': 'Smart Living',
      'deskripsi': 'Kualitas hidup masyarakat',
      'ikon': Icons.favorite_outline,
    },
    {
      'nama': 'Smart Mobility',
      'deskripsi': 'Transportasi cerdas dan terintegrasi',
      'ikon': Icons.directions_bus_outlined,
    },
    {
      'nama': 'Smart Environment',
      'deskripsi': 'Lingkungan kota berkelanjutan',
      'ikon': Icons.eco_outlined,
    },
    {
      'nama': 'Smart People',
      'deskripsi': 'Masyarakat kreatif dan inovatif',
      'ikon': Icons.groups_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER SAPAAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Warga Nusantara!',
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications_none, color: navy),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // KARTU UTAMA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_city,
                    color: Colors.white,
                    size: 34,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nusantara Cerdas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mewujudkan kota cerdas melalui teknologi, '
                    'inovasi, dan pelayanan publik yang terintegrasi.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Smart City Dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // RINGKASAN KOTA
            const Text(
              'Ringkasan Kota',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _KartuStatistik(
                    judul: 'Total Laporan',
                    jumlah: '128',
                    ikon: Icons.description_outlined,
                    warna: biru,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KartuStatistik(
                    judul: 'Laporan Selesai',
                    jumlah: '96',
                    ikon: Icons.check_circle_outline,
                    warna: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ENAM PILAR SMART CITY
            const Text(
              'Enam Pilar Smart City',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Enam aspek pembangunan kota cerdas dan berkelanjutan.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 14),

            LayoutBuilder(
              builder: (context, constraints) {
                final jumlahKolom = constraints.maxWidth >= 700 ? 3 : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daftarPilar.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: jumlahKolom,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final pilar = daftarPilar[index];

                    return _KartuPilar(
                      nama: pilar['nama'],
                      deskripsi: pilar['deskripsi'],
                      ikon: pilar['ikon'],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// WIDGET KARTU STATISTIK
class _KartuStatistik extends StatelessWidget {
  final String judul;
  final String jumlah;
  final IconData ikon;
  final Color warna;

  const _KartuStatistik({
    required this.judul,
    required this.jumlah,
    required this.ikon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: warna, size: 25),
          const SizedBox(height: 12),
          Text(
            jumlah,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            judul,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// WIDGET KARTU PILAR
class _KartuPilar extends StatelessWidget {
  final String nama;
  final String deskripsi;
  final IconData ikon;

  const _KartuPilar({
    required this.nama,
    required this.deskripsi,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, color: const Color(0xFF315A91), size: 28),
          const SizedBox(height: 12),
          Text(
            nama,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            deskripsi,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
