
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import '../cubit/theme_cubit.dart';
import 'bagian_keranjang_pengajuan.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Warga'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PENGATURAN TEMA
            Card(
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  final isDark = mode == ThemeMode.dark;

                  return SwitchListTile(
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: colors.primary,
                    ),
                    title: const Text('Mode Gelap'),
                    subtitle: Text(
                      isDark
                          ? 'Tampilan gelap sedang aktif'
                          : 'Tampilan terang sedang aktif',
                    ),
                    value: isDark,
                    onChanged: (_) {
                      context.read<ThemeCubit>().toggle();
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // PROFIL WARGA
            Card(
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person_outline, size: 36),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profil Warga',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Informasi dan aktivitas layanan warga',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Informasi Warga',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InformasiItem(
                      ikon: Icons.person_outline,
                      judul: 'Nama',
                      isi: 'Warga Nusantara',
                    ),
                    Divider(height: 24),
                    _InformasiItem(
                      ikon: Icons.location_on_outlined,
                      judul: 'Domisili',
                      isi: 'Belum diatur',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Layanan Favorit',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            BlocBuilder<FavoritCubit, Set<String>>(
              builder: (context, daftarFavorit) {
                if (daftarFavorit.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            size: 40,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          const Text('Belum ada layanan favorit'),
                          const SizedBox(height: 4),
                          Text(
                            'Tandai layanan dari halaman Layanan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: daftarFavorit.map((namaLayanan) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                        ),
                        title: Text(
                          namaLayanan,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Layanan yang ditandai sebagai favorit.',
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus dari favorit',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            context
                                .read<FavoritCubit>()
                                .batalTandai(namaLayanan);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Pengajuan Layanan',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const BagianKeranjangPengajuan(),
          ],
        ),
      ),
    );
  }
}

class _InformasiItem extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String isi;

  const _InformasiItem({
    required this.ikon,
    required this.judul,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon),
        const SizedBox(width: 12),
        Expanded(child: Text(judul)),
        Text(
          isi,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
