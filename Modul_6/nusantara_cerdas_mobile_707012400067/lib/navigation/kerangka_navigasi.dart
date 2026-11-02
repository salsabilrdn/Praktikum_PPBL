
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pengajuan_cubit.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart' as layanan;
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

  final List<Widget> daftarHalaman = const [
    HalamanBeranda(),
    layanan.HalamanLayanan(),
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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool layarLebar = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        title: const Text(
          'Nusantara Cerdas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: colors.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_city,
                    color: colors.onPrimary,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nusantara Cerdas',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Smart City Mobile Application',
                    style: TextStyle(
                      color: colors.onPrimary.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < namaMenu.length; i++)
              ListTile(
                leading: Icon(ikonMenu[i]),
                title: Text(namaMenu[i]),
                selected: halamanAktif == i,
                selectedColor: colors.primary,
                selectedTileColor: colors.primaryContainer,
                onTap: () => pilihDariDrawer(i),
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                'MENU PENDUKUNG',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.onSurfaceVariant,
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
              backgroundColor: colors.surface,
              selectedIndex: halamanAktif,
              onDestinationSelected: pilihHalaman,
              labelType: NavigationRailLabelType.all,
              indicatorColor: colors.secondaryContainer,
              selectedIconTheme: IconThemeData(color: colors.primary),
              unselectedIconTheme: IconThemeData(
                color: colors.onSurfaceVariant,
              ),
              selectedLabelTextStyle: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: colors.onSurfaceVariant,
              ),
              destinations: [
                for (int i = 0; i < namaMenu.length; i++)
                  NavigationRailDestination(
                    icon: i == 2
                        ? IkonWargaDenganBadge(
                            warna: colors.onSurfaceVariant,
                          )
                        : Icon(ikonMenu[i]),
                    selectedIcon: i == 2
                        ? IkonWargaDenganBadge(warna: colors.primary)
                        : Icon(ikonMenu[i]),
                    label: Text(namaMenu[i]),
                  ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: halamanAktif,
              children: daftarHalaman,
            ),
          ),
        ],
      ),
      bottomNavigationBar: layarLebar
          ? null
          : SafeArea(
              top: false,
              child: Container(
                height: 72,
                color: colors.surface,
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
                                        ? colors.secondaryContainer
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: i == 2
                                      ? IkonWargaDenganBadge(
                                          warna: halamanAktif == i
                                              ? colors.primary
                                              : colors.onSurfaceVariant,
                                        )
                                      : Icon(
                                          ikonMenu[i],
                                          color: halamanAktif == i
                                              ? colors.primary
                                              : colors.onSurfaceVariant,
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
                                        ? colors.primary
                                        : colors.onSurfaceVariant,
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

class IkonWargaDenganBadge extends StatelessWidget {
  final Color warna;

  const IkonWargaDenganBadge({
    super.key,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PengajuanCubit, List<String>, int>(
      selector: (daftarPengajuan) => daftarPengajuan.length,
      builder: (context, totalPengajuan) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.person_outline, color: warna),
            if (totalPengajuan > 0)
              Positioned(
                right: -10,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 17,
                    minHeight: 17,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$totalPengajuan',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
