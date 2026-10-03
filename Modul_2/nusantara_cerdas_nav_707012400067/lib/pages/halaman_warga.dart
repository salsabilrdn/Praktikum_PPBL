import 'package:flutter/material.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Profil Warga',
              style: TextStyle(
                color: navy,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Informasi akun dan aktivitas warga.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // KARTU PROFIL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFFE8EDF6),
                    child: Icon(Icons.person_outline, size: 42, color: navy),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Salsabila Rahmadina',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Warga Terdaftar',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  SizedBox(height: 12),
                  Chip(
                    avatar: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    label: Text('Akun Aktif'),
                    backgroundColor: Color(0xFFE8F5E9),
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // INFORMASI AKUN
            const Text(
              'Informasi Akun',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                children: [
                  _InformasiItem(
                    ikon: Icons.person_outline,
                    judul: 'Nama Lengkap',
                    isi: 'Salsabila Rahmadina',
                  ),
                  Divider(height: 24),
                  _InformasiItem(
                    ikon: Icons.verified_user_outlined,
                    judul: 'Status Akun',
                    isi: 'Warga Terdaftar',
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

            // AKTIVITAS WARGA
            const Text(
              'Aktivitas Warga',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Riwayat laporan akan dibuka pada tahap berikutnya.',
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE8EDF6),
                      child: Icon(Icons.history, color: biru),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riwayat Laporan',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Lihat laporan yang pernah dibuat.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.black38),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET INFORMASI AKUN
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
        Icon(ikon, color: const Color(0xFF315A91), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                isi,
                style: const TextStyle(
                  color: Color(0xFF172B4D),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
