
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
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colors.surface,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Publik',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan layanan yang kamu butuhkan.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: colors.surface,
            child: TabBar(
              labelColor: colors.primary,
              unselectedLabelColor: colors.onSurfaceVariant,
              indicatorColor: colors.primary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.assignment_outlined),
                  text: 'Perizinan',
                ),
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: daftarLayanan.length,
      itemBuilder: (context, index) {
        final dataLayanan = daftarLayanan[index];
        final String namaLayanan = dataLayanan['nama'] as String;
        final String deskripsi = dataLayanan['deskripsi'] as String;
        final IconData ikon = dataLayanan['ikon'] as IconData;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: colors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    ikon,
                    color: colors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaLayanan,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        deskripsi,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: dataLayanan,
                          );
                        },
                        child: const Text('Lihat Detail'),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<FavoritCubit, Set<String>>(
                  builder: (context, daftarFavorit) {
                    final bool isFavorit =
                        daftarFavorit.contains(namaLayanan);

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
                        color: isFavorit
                            ? Colors.amber
                            : colors.onSurfaceVariant,
                        size: 26,
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
