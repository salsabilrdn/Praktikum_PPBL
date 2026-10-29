import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/halaman_beranda.dart';
import '../pages/halaman_input_prediksi.dart';
import '../pages/halaman_statistik.dart';
import '../state/app_state.dart';
import '../widget/prediksi_card.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  static const _judul = ['Beranda', 'Prediksi', 'Statistik', 'Pengaturan'];
  static const _ikon = [
    Icons.home_outlined,
    Icons.analytics_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final halaman = [
      const HalamanBeranda(),
      const HalamanPrediksi(),
      const HalamanStatistik(),
      const HalamanPengaturan(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('AgriClima - ${_judul[_indeksTerpilih]}')),
      body: IndexedStack(index: _indeksTerpilih, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeksTerpilih,
        onDestinationSelected: (indeks) {
          setState(() => _indeksTerpilih = indeks);
        },
        destinations: List.generate(
          _judul.length,
          (index) => NavigationDestination(
            icon: Icon(_ikon[index]),
            selectedIcon: Icon(_ikon[index]),
            label: _judul[index],
          ),
        ),
      ),
    );
  }
}

class HalamanPrediksi extends StatefulWidget {
  const HalamanPrediksi({super.key});

  @override
  State<HalamanPrediksi> createState() => _HalamanPrediksiState();
}

class _HalamanPrediksiState extends State<HalamanPrediksi> {
  int? _filterPetak;

  Future<void> _bukaForm(BuildContext context) async {
    final data = await Navigator.push<PrediksiData>(
      context,
      MaterialPageRoute(builder: (_) => const HalamanInputPrediksi()),
    );
    if (data != null && context.mounted) {
      context.read<AppState>().tambahPrediksi(data);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Data tersimpan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final data = _filterPetak == null
            ? state.prediksi
            : state.prediksi
                  .where((item) => item.petak == _filterPetak)
                  .toList();
        final optimal = data.where((item) => item.status == 'Optimal').length;
        final perluTindakan = data
            .where((item) => item.status != 'Optimal')
            .length;

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              Text(
                'Riwayat Prediksi',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _filter(context),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ringkasan(
                      'Total',
                      '${data.length}',
                      Icons.list_alt,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ringkasan(
                      'Optimal',
                      '$optimal',
                      Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ringkasan(
                      'Perlu tindakan',
                      '$perluTindakan',
                      Icons.warning_amber_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (data.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Belum ada data prediksi. Tekan tombol + untuk menambahkan.',
                    ),
                  ),
                )
              else
                ...data.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PrediksiCard(data: item),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _bukaForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Prediksi baru'),
          ),
        );
      },
    );
  }

  Widget _filter(BuildContext context) {
    final labels = <int?, String>{null: 'Semua', 1: 'Petak 1', 2: 'Petak 2'};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.entries.map((entry) {
          final aktif = _filterPetak == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: aktif,
              onSelected: (_) => setState(() => _filterPetak = entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _ringkasan(String label, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  Future<void> _hapusData(BuildContext context) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus data?'),
        content: const Text('Semua data prediksi akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (setuju == true && context.mounted) {
      context.read<AppState>().hapusSemuaPrediksi();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Data dihapus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Sesuaikan tampilan aplikasi'),
            value: state.modeGelap,
            onChanged: context.read<AppState>().ubahModeGelap,
          ),
          const Divider(),
          FilledButton.icon(
            onPressed: () {
              context.read<AppState>().muatDataSimulasi();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('10 data simulasi dimuat')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Muat Data Simulasi'),
          ),
          OutlinedButton.icon(
            onPressed: state.prediksi.isEmpty
                ? null
                : () => _hapusData(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus Data'),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versi aplikasi'),
            subtitle: Text(
              'AgriClima LSTM 1.0.0 • ${state.prediksi.length} data',
            ),
          ),
        ],
      ),
    );
  }
}
