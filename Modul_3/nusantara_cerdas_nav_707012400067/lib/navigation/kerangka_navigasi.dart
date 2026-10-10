import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_warga.dart';

import 'app_routes.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int halamanAktif = 0;

  static const Color navy = Color(0xFF172B4D);
  static const Color background = Color(0xFFF4F6FA);

  // Daftar halaman utama
  final List<Widget> daftarHalaman = const [
    HalamanBeranda(),
    HalamanLayanan(),
    HalamanWarga(),
  ];

  // Mengganti halaman utama
  void pilihHalaman(int index) {
    setState(() {
      halamanAktif = index;
    });
  }

  // Membuka halaman pendukung melalui Named Routes
  void bukaHalamanPendukung(String route) {
    Navigator.pop(context);

    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil jumlah pengajuan dari PengajuanModel
    final int totalPengajuan = context.select<PengajuanModel, int>(
      (model) => model.totalPengajuan,
    );

    // Menentukan ukuran layar
    final bool layarLebar = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: background,

      // AppBar utama
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Nusantara Cerdas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // Drawer atau menu samping
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: navy),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.location_city, color: Colors.white, size: 42),
                  SizedBox(height: 12),
                  Text(
                    'Nusantara Cerdas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Smart City Mobile Application',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Menu utama
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selected: halamanAktif == 0,
              onTap: () {
                Navigator.pop(context);
                pilihHalaman(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.miscellaneous_services_outlined),
              title: const Text('Layanan'),
              selected: halamanAktif == 1,
              onTap: () {
                Navigator.pop(context);
                pilihHalaman(1);
              },
            ),

            ListTile(
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.person_outline),

                  if (totalPengajuan > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: _BadgeJumlah(jumlah: totalPengajuan),
                    ),
                ],
              ),
              title: const Text('Warga'),
              selected: halamanAktif == 2,
              onTap: () {
                Navigator.pop(context);
                pilihHalaman(2);
              },
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                'MENU PENDUKUNG',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Pengaturan
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan Kota'),
              onTap: () {
                bukaHalamanPendukung(AppRoutes.pengaturan);
              },
            ),

            // Tentang aplikasi
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                bukaHalamanPendukung(AppRoutes.tentang);
              },
            ),

            // Keluar
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur keluar belum diaktifkan.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Isi halaman dan navigasi adaptif
      body: Row(
        children: [
          if (layarLebar)
            NavigationRail(
              backgroundColor: Colors.white,
              selectedIndex: halamanAktif,
              onDestinationSelected: pilihHalaman,
              labelType: NavigationRailLabelType.all,

              selectedIconTheme: const IconThemeData(color: navy),

              unselectedIconTheme: const IconThemeData(color: Colors.black54),

              selectedLabelTextStyle: const TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
              ),

              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Beranda'),
                ),

                const NavigationRailDestination(
                  icon: Icon(Icons.miscellaneous_services_outlined),
                  selectedIcon: Icon(Icons.miscellaneous_services),
                  label: Text('Layanan'),
                ),

                NavigationRailDestination(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person_outline),

                      if (totalPengajuan > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: _BadgeJumlah(jumlah: totalPengajuan),
                        ),
                    ],
                  ),

                  selectedIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person),

                      if (totalPengajuan > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: _BadgeJumlah(jumlah: totalPengajuan),
                        ),
                    ],
                  ),

                  label: const Text('Warga'),
                ),
              ],
            ),

          // Menampilkan halaman sesuai pilihan
          Expanded(
            child: IndexedStack(index: halamanAktif, children: daftarHalaman),
          ),
        ],
      ),

      // NavigationBar hanya untuk layar sempit
      bottomNavigationBar: layarLebar
          ? null
          : NavigationBar(
              backgroundColor: Colors.white,
              selectedIndex: halamanAktif,
              onDestinationSelected: pilihHalaman,
              indicatorColor: const Color(0xFFE1E8F2),

              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Beranda',
                ),

                const NavigationDestination(
                  icon: Icon(Icons.miscellaneous_services_outlined),
                  selectedIcon: Icon(Icons.miscellaneous_services),
                  label: 'Layanan',
                ),

                NavigationDestination(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person_outline),

                      if (totalPengajuan > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: _BadgeJumlah(jumlah: totalPengajuan),
                        ),
                    ],
                  ),

                  selectedIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person),

                      if (totalPengajuan > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: _BadgeJumlah(jumlah: totalPengajuan),
                        ),
                    ],
                  ),

                  label: 'Warga',
                ),
              ],
            ),
    );
  }
}

// BADGE JUMLAH PENGAJUAN
class _BadgeJumlah extends StatelessWidget {
  final int jumlah;

  const _BadgeJumlah({required this.jumlah});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        jumlah.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
