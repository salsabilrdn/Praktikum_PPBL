import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../cubit/sensor_cubit.dart';
import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/pembacaan_sensor.dart';
import '../models/status_siaga.dart';
import '../widgets/dialog_koreksi.dart';
import '../widgets/status_badge.dart';

class HalamanRiwayatSensor extends StatelessWidget {
  const HalamanRiwayatSensor({super.key});
  Future<void> edit(BuildContext context, PembacaanSensor item) async {
    final n = await showDialog<double>(
      context: context,
      builder: (_) => DialogKoreksi(data: item),
    );
    if (n == null || !context.mounted) return;
    final ok = await context.read<SensorCubit>().koreksi(item.id, n);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Nilai berhasil dikoreksi.' : 'Nilai belum tersimpan.',
          ),
        ),
      );
    }
  }

  Future<bool> hapus(BuildContext context, PembacaanSensor item) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pembacaan?'),
        content: Text(
          '${item.jenisSensor.label} di ${item.lokasiPos} akan dihapus.',
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
    if (yakin == true && context.mounted) {
      final ok = await context.read<SensorCubit>().hapus(item.id);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Data belum terhapus.')));
      }
    }
    return false;
  }

  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<Box<PembacaanSensor>>(
    valueListenable: HiveHelper.instance.box.listenable(),
    builder: (context, box, _) =>
        ValueListenableBuilder<Map<JenisSensor, BatasSensor>>(
          valueListenable: PengaturanHelper.instance.ambang,
          builder: (context, ambang, _) {
            final daftar = HiveHelper.instance.riwayat;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Riwayat Sensor'),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(54),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        StatusBadge(status: StatusSiaga.dariPembacaan(daftar)),
                        Expanded(
                          child: Text(
                            '${daftar.length} catatan',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: daftar.isEmpty
                  ? const Center(child: Text('Belum ada riwayat sensor.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: daftar.length,
                      itemBuilder: (context, index) {
                        final item = daftar[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => hapus(context, item),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.jenisSensor.label,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Koreksi ${item.lokasiPos}',
                                          onPressed: () => edit(context, item),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${item.nilaiTampilan} ${item.jenisSensor.satuan}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(item.lokasiPos),
                                    Text(item.waktuTampilan),
                                    const SizedBox(height: 8),
                                    StatusBadge(
                                      status: StatusSiaga.untuk(item),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
  );
}
