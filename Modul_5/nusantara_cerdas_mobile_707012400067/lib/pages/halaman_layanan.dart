import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import '../navigation/app_routes.dart';

class HalamanLayanan extends StatelessWidget {
  const HalamanLayanan({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color background = Color(0xFFF4F6FA);

  static const List<Map<String, dynamic>> layananPerizinan = [
    {
      'nama': 'Izin Usaha',
      'deskripsi': 'Pengajuan izin pendirian usaha',
      'ikon': Icons.store_outlined,
    },
    {
      'nama': 'Izin Bangunan',
      'deskripsi': 'Pengurusan izin bangunan gedung',
      'ikon': Icons.apartment_outlined,
    },
    {
      'nama': 'Surat Domisili',
      'deskripsi': 'Pengajuan surat keterangan domisili',
      'ikon': Icons.description_outlined,
    },
  ];

  static const List<Map<String, dynamic>> layananKesehatan = [
    {
      'nama': 'Pendaftaran Puskesmas',
      'deskripsi': 'Informasi pendaftaran layanan puskesmas',
      'ikon': Icons.local_hospital_outlined,
    },
    {
      'nama': 'Jadwal Imunisasi',
      'deskripsi': 'Informasi jadwal imunisasi warga',
      'ikon': Icons.vaccines_outlined,
    },
    {
      'nama': 'Layanan Kesehatan Warga',
      'deskripsi': 'Informasi pelayanan kesehatan masyarakat',
      'ikon': Icons.health_and_safety_outlined,
    },
  ];

  static const List<Map<String, dynamic>> layananTransportasi = [
    {
      'nama': 'Informasi Transportasi',
      'deskripsi': 'Informasi layanan transportasi umum',
      'ikon': Icons.directions_bus_outlined,
    },
    {
      'nama': 'Pengaduan Jalan',
      'deskripsi': 'Pelaporan kerusakan jalan',
      'ikon': Icons.add_road_outlined,
    },
    {
      'nama': 'Informasi Lalu Lintas',
      'deskripsi': 'Informasi kondisi lalu lintas kota',
      'ikon': Icons.traffic_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Publik',
                  style: TextStyle(
                    color: navy,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan layanan yang kamu butuhkan.',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: navy,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFF355F96),
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

class _DaftarLayanan extends StatelessWidget {
  final List<Map<String, dynamic>> daftarLayanan;

  const _DaftarLayanan({required this.daftarLayanan});

  static const Color navy = Color(0xFF172B4D);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: daftarLayanan.length,
      itemBuilder: (context, index) {
        final layanan = daftarLayanan[index];
        final String namaLayanan = layanan['nama'] as String;
        final String deskripsi = layanan['deskripsi'] as String;
        final IconData ikon = layanan['ikon'] as IconData;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE0E6EF)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(ikon, color: const Color(0xFF355F96), size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaLayanan,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        deskripsi,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: layanan,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF355F96),
                          side: const BorderSide(color: Color(0xFF355F96)),
                        ),
                        child: const Text('Lihat Detail'),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<FavoritCubit, Set<String>>(
                  builder: (context, daftarFavorit) {
                    final bool isFavorit = daftarFavorit.contains(namaLayanan);

                    return IconButton(
                      tooltip: isFavorit
                          ? 'Hapus dari favorit'
                          : 'Tambahkan ke favorit',
                      onPressed: () {
                        final cubit = context.read<FavoritCubit>();

                        if (isFavorit) {
                          cubit.batalTandai(namaLayanan);
                        } else {
                          cubit.tandai(namaLayanan);
                        }
                      },
                      icon: Icon(
                        isFavorit
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isFavorit ? Colors.amber : Colors.black38,
                        size: 28,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
