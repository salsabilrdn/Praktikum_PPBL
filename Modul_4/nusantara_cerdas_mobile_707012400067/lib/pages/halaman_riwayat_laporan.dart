import 'package:flutter/material.dart';

class HalamanRiwayatLaporan extends StatelessWidget {
  const HalamanRiwayatLaporan({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  // Data contoh laporan warga
  final List<Map<String, String>> daftarLaporan = const [
    {
      'judul': 'Lampu Jalan Mati',
      'kategori': 'Infrastruktur',
      'tanggal': '02 Oktober 2026',
      'status': 'Diproses',
    },
    {
      'judul': 'Sampah Menumpuk',
      'kategori': 'Lingkungan',
      'tanggal': '01 Oktober 2026',
      'status': 'Selesai',
    },
    {
      'judul': 'Jalan Rusak',
      'kategori': 'Infrastruktur',
      'tanggal': '29 September 2026',
      'status': 'Menunggu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text('Riwayat Laporan'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // RINGKASAN LAPORAN
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _KartuRingkasan(
                    judul: 'Total Laporan',
                    jumlah: '${daftarLaporan.length}',
                    ikon: Icons.description_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KartuRingkasan(
                    judul: 'Laporan Selesai',
                    jumlah:
                        '${daftarLaporan.where((laporan) => laporan['status'] == 'Selesai').length}',
                    ikon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),

          // JUDUL DAFTAR LAPORAN
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Laporan',
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // DAFTAR LAPORAN
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: daftarLaporan.length,
              itemBuilder: (context, index) {
                final laporan = daftarLaporan[index];

                return _KartuLaporan(
                  judul: laporan['judul']!,
                  kategori: laporan['kategori']!,
                  tanggal: laporan['tanggal']!,
                  status: laporan['status']!,
                );
              },
            ),
          ),
        ],
      ),

      // TOMBOL TAMBAH LAPORAN
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Fitur tambah laporan akan dikembangkan selanjutnya.',
              ),
            ),
          );
        },
        backgroundColor: biru,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM APP BAR
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Menu Beranda')));
                },
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Beranda',
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Menu Laporan')));
                },
                icon: const Icon(Icons.description_outlined),
                tooltip: 'Laporan',
              ),

              const SizedBox(width: 48),

              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menu Notifikasi')),
                  );
                },
                icon: const Icon(Icons.notifications_none),
                tooltip: 'Notifikasi',
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Menu Profil')));
                },
                icon: const Icon(Icons.person_outline),
                tooltip: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET KARTU RINGKASAN
class _KartuRingkasan extends StatelessWidget {
  final String judul;
  final String jumlah;
  final IconData ikon;

  const _KartuRingkasan({
    required this.judul,
    required this.jumlah,
    required this.ikon,
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
          Icon(ikon, color: const Color(0xFF315A91), size: 25),
          const SizedBox(height: 10),
          Text(
            jumlah,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            judul,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// WIDGET KARTU LAPORAN
class _KartuLaporan extends StatelessWidget {
  final String judul;
  final String kategori;
  final String tanggal;
  final String status;

  const _KartuLaporan({
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color warnaStatus;

    if (status == 'Selesai') {
      warnaStatus = Colors.green;
    } else if (status == 'Diproses') {
      warnaStatus = Colors.orange;
    } else {
      warnaStatus = const Color(0xFF315A91);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8EDF6),
            child: Icon(Icons.description_outlined, color: Color(0xFF315A91)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: Color(0xFF172B4D),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$kategori • $tanggal',
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: warnaStatus,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}
