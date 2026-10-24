import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import 'bagian_keranjang_pengajuan.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Warga'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFIL WARGA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE8EDF6),
                    child: Icon(Icons.person_outline, size: 36, color: navy),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Warga',
                          style: TextStyle(
                            color: navy,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Informasi dan aktivitas layanan warga',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // INFORMASI WARGA
            const Text(
              'Informasi Warga',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
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

            const SizedBox(height: 24),

            // LAYANAN FAVORIT
            const Text(
              'Layanan Favorit',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            BlocBuilder<FavoritCubit, Set<String>>(
              builder: (context, daftarFavorit) {
                if (daftarFavorit.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.star_border_rounded,
                          size: 40,
                          color: Colors.black38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Belum ada layanan favorit',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tandai layanan dari halaman Layanan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black38),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: daftarFavorit.map((namaLayanan) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFF3CD),
                          child: Icon(Icons.star_rounded, color: Colors.amber),
                        ),
                        title: Text(
                          namaLayanan,
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Layanan yang ditandai sebagai favorit.',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus dari favorit',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            context.read<FavoritCubit>().batalTandai(
                              namaLayanan,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // KERANJANG PENGAJUAN
            const Text(
              'Pengajuan Layanan',
              style: TextStyle(
                color: navy,
                fontSize: 18,
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
        Icon(ikon, color: const Color(0xFF315A91)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(judul, style: const TextStyle(color: Colors.black54)),
        ),
        Text(
          isi,
          style: const TextStyle(
            color: Color(0xFF172B4D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
