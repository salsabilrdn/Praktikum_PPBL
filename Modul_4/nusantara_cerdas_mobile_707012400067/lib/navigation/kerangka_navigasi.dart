import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_warga.dart';
import '../pages/halaman_chat.dart';
import '../pages/halaman_kantor.dart';
import '../pages/halaman_statistik.dart';
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

  final List<Widget> daftarHalaman = const [
    HalamanBeranda(),
    HalamanLayanan(),
    HalamanWarga(),
    HalamanChat(),
    HalamanKantor(),
    HalamanStatistik(),
  ];

  final List<String> namaMenu = const [
    'Beranda',
    'Layanan',
    'Warga',
    'Chat',
    'Peta Kantor',
    'Statistik',
  ];

  final List<IconData> ikonMenu = const [
    Icons.home_outlined,
    Icons.miscellaneous_services_outlined,
    Icons.person_outline,
    Icons.chat_bubble_outline,
    Icons.map_outlined,
    Icons.bar_chart_outlined,
  ];

  void pilihHalaman(int index) {
    setState(() {
      halamanAktif = index;
    });
  }

  void pilihDariDrawer(int index) {
    Navigator.pop(context);
    pilihHalaman(index);
  }

  void bukaHalamanPendukung(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final int totalPengajuan = context.select<PengajuanModel, int>(
      (model) => model.totalPengajuan,
    );

    final bool layarLebar = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Nusantara Cerdas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

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

            for (int i = 0; i < namaMenu.length; i++)
              ListTile(
                leading: Icon(ikonMenu[i]),
                title: Text(namaMenu[i]),
                selected: halamanAktif == i,
                selectedColor: navy,
                onTap: () => pilihDariDrawer(i),
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

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan Kota'),
              onTap: () => bukaHalamanPendukung(AppRoutes.pengaturan),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () => bukaHalamanPendukung(AppRoutes.tentang),
            ),

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
                for (int i = 0; i < namaMenu.length; i++)
                  NavigationRailDestination(
                    icon: Icon(ikonMenu[i]),
                    selectedIcon: Icon(
                      i == 0
                          ? Icons.home
                          : i == 1
                          ? Icons.miscellaneous_services
                          : i == 2
                          ? Icons.person
                          : ikonMenu[i],
                    ),
                    label: Text(namaMenu[i]),
                  ),
              ],
            ),

          Expanded(
            child: IndexedStack(index: halamanAktif, children: daftarHalaman),
          ),
        ],
      ),

      bottomNavigationBar: layarLebar
          ? null
          : SafeArea(
              top: false,
              child: Container(
                height: 72,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < namaMenu.length; i++)
                        InkWell(
                          onTap: () => pilihHalaman(i),
                          child: SizedBox(
                            width: 82,
                            height: 72,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: halamanAktif == i
                                        ? const Color(0xFFE1E8F2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Icon(
                                    ikonMenu[i],
                                    color: halamanAktif == i
                                        ? navy
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  namaMenu[i],
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: halamanAktif == i
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: halamanAktif == i
                                        ? navy
                                        : Colors.black87,
                                  ),
                                ),
                                if (i == 2 && totalPengajuan > 0)
                                  Text(
                                    '$totalPengajuan pengajuan',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
