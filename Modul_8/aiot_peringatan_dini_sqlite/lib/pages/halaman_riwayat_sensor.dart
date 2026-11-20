import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../db/database_helper.dart';
import '../models/pembacaan_sensor.dart';
import '../models/status_siaga.dart';
import '../widgets/dialog_koreksi.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_badge.dart';

class HalamanRiwayatSensor extends StatefulWidget {
  const HalamanRiwayatSensor({super.key});
  @override
  State<HalamanRiwayatSensor> createState() => _HalamanRiwayatSensorState();
}

class _HalamanRiwayatSensorState extends State<HalamanRiwayatSensor> {
  late Future<List<PembacaanSensor>> _riwayat;
  @override
  void initState() {
    super.initState();
    _riwayat = _baca();
  }

  Future<List<PembacaanSensor>> _baca() =>
      context.read<DatabaseHelper>().ambilSemuaPembacaan();
  Future<void> _muatUlang() async {
    final future = _baca();
    setState(() {
      _riwayat = future;
    });
    try {
      await future;
    } catch (_) {
      _pesan('Riwayat belum berhasil dibaca.');
    }
  }

  void _pesan(String pesan) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  Future<void> _koreksi(PembacaanSensor data) async {
    final nilai = await showDialog<double>(
      context: context,
      builder: (_) => DialogKoreksi(data: data),
    );
    if (nilai == null || !mounted) return;
    final berhasil = await context.read<SensorCubit>().koreksi(data.id!, nilai);
    if (!mounted) return;
    if (berhasil) {
      await _muatUlang();
      _pesan('Nilai pembacaan berhasil dikoreksi.');
    } else {
      _pesan('Koreksi belum tersimpan. Silakan coba lagi.');
    }
  }

  Future<bool> _konfirmasiHapus(PembacaanSensor data) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pembacaan?'),
        content: Text(
          '${data.jenisSensor.label} di ${data.lokasiPos} akan dihapus dari riwayat.',
        ),
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
    if (yakin != true || !mounted) return false;
    final berhasil = await context.read<SensorCubit>().hapus(data.id!);
    if (!mounted) return false;
    if (berhasil) {
      await _muatUlang();
      _pesan('Pembacaan berhasil dihapus.');
    } else {
      _pesan('Pembacaan belum terhapus. Silakan coba lagi.');
    }
    // SQLite menjadi sumber daftar baru, sehingga Dismissible tidak menyisakan widget lama.
    return false;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<PembacaanSensor>>(
    future: _riwayat,
    builder: (context, snapshot) {
      final daftar = snapshot.data ?? [];
      final siap =
          snapshot.connectionState == ConnectionState.done &&
          !snapshot.hasError;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Sensor'),
          actions: [
            IconButton(
              tooltip: 'Muat ulang riwayat',
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(58),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                children: [
                  StatusBadge(
                    status: siap
                        ? StatusSiaga.dariPembacaan(daftar)
                        : StatusSiaga.belumAdaData,
                  ),
                  const Spacer(),
                  Text(siap ? '${daftar.length} catatan' : 'Memuat data...'),
                ],
              ),
            ),
          ),
        ),
        body: _isi(snapshot, daftar),
      );
    },
  );
  Widget _isi(
    AsyncSnapshot<List<PembacaanSensor>> snapshot,
    List<PembacaanSensor> daftar,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Riwayat belum berhasil dibaca.'),
            TextButton(onPressed: _muatUlang, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    if (daftar.isEmpty) {
      return const Center(child: Text('Belum ada riwayat sensor.'));
    }
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftar.length,
        itemBuilder: (context, index) {
          final data = daftar[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey(data.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _konfirmasiHapus(data),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 22),
                color: Theme.of(context).colorScheme.errorContainer,
                child: const Icon(Icons.delete_outline),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            SensorCard.ikon(data.jenisSensor),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data.jenisSensor.label,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Koreksi pembacaan ${data.id}',
                            onPressed: () => _koreksi(data),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                      Text(
                        '${data.nilaiTampilan} ${data.jenisSensor.satuan}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 5),
                      Text(data.lokasiPos),
                      const SizedBox(height: 5),
                      Text(
                        '#${data.id} • ${data.waktuTampilan}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(status: StatusSiaga.untuk(data)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
