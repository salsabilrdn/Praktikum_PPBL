import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorit_model.dart';

class HalamanLayanan extends StatelessWidget {
  const HalamanLayanan({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  // Data layanan Perizinan
  final List<Map<String, dynamic>> layananPerizinan = const [
    {
      'nama': 'Izin Usaha',
      'deskripsi': 'Pengajuan izin pendirian usaha',
      'ikon': Icons.store_outlined,
      'instansi': 'Dinas Penanaman Modal dan Pelayanan Terpadu',
      'jam': 'Senin - Jumat, 08.00 - 15.00',
      'detail':
          'Layanan pengajuan izin usaha bagi masyarakat '
          'yang ingin mendirikan dan menjalankan kegiatan usaha.',
    },
    {
      'nama': 'Izin Bangunan',
      'deskripsi': 'Pengurusan izin bangunan gedung',
      'ikon': Icons.apartment_outlined,
      'instansi': 'Dinas Pekerjaan Umum',
      'jam': 'Senin - Jumat, 08.00 - 15.00',
      'detail':
          'Layanan pengurusan persetujuan bangunan gedung '
          'sesuai dengan ketentuan yang berlaku.',
    },
    {
      'nama': 'Surat Domisili',
      'deskripsi': 'Pengajuan surat keterangan domisili',
      'ikon': Icons.description_outlined,
      'instansi': 'Kantor Kelurahan',
      'jam': 'Senin - Jumat, 08.00 - 14.00',
      'detail':
          'Layanan penerbitan surat keterangan domisili '
          'untuk kebutuhan administrasi masyarakat.',
    },
  ];

  // Data layanan Kesehatan
  final List<Map<String, dynamic>> layananKesehatan = const [
    {
      'nama': 'Layanan Puskesmas',
      'deskripsi': 'Informasi fasilitas kesehatan terdekat',
      'ikon': Icons.local_hospital_outlined,
      'instansi': 'Dinas Kesehatan',
      'jam': 'Senin - Sabtu, 08.00 - 14.00',
      'detail':
          'Informasi mengenai fasilitas puskesmas, '
          'pelayanan kesehatan, dan lokasi fasilitas kesehatan.',
    },
    {
      'nama': 'Jadwal Imunisasi',
      'deskripsi': 'Informasi jadwal imunisasi masyarakat',
      'ikon': Icons.vaccines_outlined,
      'instansi': 'Puskesmas Setempat',
      'jam': 'Sesuai jadwal puskesmas',
      'detail':
          'Informasi jadwal pelaksanaan imunisasi '
          'untuk membantu masyarakat memperoleh layanan kesehatan.',
    },
    {
      'nama': 'Layanan Ambulans',
      'deskripsi': 'Informasi akses layanan ambulans',
      'ikon': Icons.emergency_outlined,
      'instansi': 'Dinas Kesehatan',
      'jam': '24 Jam',
      'detail':
          'Informasi akses layanan ambulans untuk '
          'membantu masyarakat dalam kondisi darurat.',
    },
  ];

  // Data layanan Transportasi
  final List<Map<String, dynamic>> layananTransportasi = const [
    {
      'nama': 'Informasi Angkot',
      'deskripsi': 'Informasi rute dan trayek angkot',
      'ikon': Icons.directions_bus_outlined,
      'instansi': 'Dinas Perhubungan',
      'jam': 'Informasi tersedia setiap saat',
      'detail':
          'Informasi rute, trayek, dan transportasi '
          'angkutan kota untuk membantu mobilitas masyarakat.',
    },
    {
      'nama': 'Jadwal Bus',
      'deskripsi': 'Informasi jadwal keberangkatan bus',
      'ikon': Icons.directions_bus_filled_outlined,
      'instansi': 'Dinas Perhubungan',
      'jam': 'Sesuai jadwal operasional',
      'detail':
          'Informasi jadwal dan waktu keberangkatan '
          'bus untuk memudahkan perjalanan masyarakat.',
    },
    {
      'nama': 'Pengaduan Transportasi',
      'deskripsi': 'Pelaporan masalah transportasi umum',
      'ikon': Icons.report_problem_outlined,
      'instansi': 'Dinas Perhubungan',
      'jam': 'Layanan pengaduan daring',
      'detail':
          'Layanan untuk menyampaikan keluhan atau '
          'laporan terkait fasilitas dan transportasi umum.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // HEADER HALAMAN
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Publik',
                  style: TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Temukan layanan yang kamu butuhkan.',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),

          // TAB BAR
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: navy,
              unselectedLabelColor: Colors.black54,
              indicatorColor: biru,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.assignment_outlined), text: 'Perizinan'),
                Tab(
                  icon: Icon(Icons.health_and_safety_outlined),
                  text: 'Kesehatan',
                ),
                Tab(
                  icon: Icon(Icons.directions_bus_outlined),
                  text: 'Transportasi',
                ),
              ],
            ),
          ),

          // KONTEN TAB
          Expanded(
            child: TabBarView(
              children: [
                _DaftarLayanan(daftarLayanan: layananPerizinan),
                _DaftarLayanan(daftarLayanan: layananKesehatan),
                _DaftarLayanan(daftarLayanan: layananTransportasi),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET UNTUK MENAMPILKAN DAFTAR LAYANAN
class _DaftarLayanan extends StatelessWidget {
  final List<Map<String, dynamic>> daftarLayanan;

  const _DaftarLayanan({required this.daftarLayanan});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarLayanan.length,
      itemBuilder: (context, index) {
        final layanan = daftarLayanan[index];

        final namaLayanan = layanan['nama'] as String;

        final isFavorit = context.watch<FavoritModel>().isFavorit(namaLayanan);

        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE8ECF2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // IKON LAYANAN
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    layanan['ikon'],
                    color: const Color(0xFF315A91),
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                // INFORMASI LAYANAN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        layanan['nama'],
                        style: const TextStyle(
                          color: Color(0xFF172B4D),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        layanan['deskripsi'],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 9),

                      // TOMBOL DETAIL
                      OutlinedButton(
                        onPressed: () async {
                          final hasil = await Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: layanan,
                          );

                          if (!context.mounted) return;

                          if (hasil != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(hasil.toString()),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF315A91),
                          side: const BorderSide(color: Color(0xFF315A91)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Lihat Detail',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),

                // TOMBOL FAVORIT
                IconButton(
                  onPressed: () {
                    final model = context.read<FavoritModel>();

                    if (isFavorit) {
                      model.batalTandai(namaLayanan);
                    } else {
                      model.tandai(namaLayanan);
                    }
                  },
                  icon: Icon(
                    isFavorit ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFavorit ? Colors.amber : Colors.black38,
                  ),
                ),

                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        );
      },
    );
  }
}
