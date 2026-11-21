import 'package:flutter/material.dart';

import 'halaman_dashboard.dart';
import 'halaman_pantauan.dart';
import 'halaman_pengaturan.dart';
import 'halaman_riwayat_sensor.dart';

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  int _indeks = 0;

  void _pilihHalaman(int indeks) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _indeks = indeks);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _indeks == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _indeks != 0) _pilihHalaman(0);
    },
    child: Scaffold(
      body: IndexedStack(
        index: _indeks,
        children: const [
          HalamanDashboard(),
          HalamanPantauan(),
          HalamanRiwayatSensor(),
          HalamanPengaturan(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: _pilihHalaman,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            selectedIcon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            selectedIcon: Icon(Icons.monitor_heart),
            label: 'Pantauan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    ),
  );
}
