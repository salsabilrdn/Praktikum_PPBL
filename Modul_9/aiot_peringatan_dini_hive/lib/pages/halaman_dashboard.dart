import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../models/pembacaan_sensor.dart';
import '../models/status_siaga.dart';
import '../widgets/form_pembacaan.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/theme_toggle_button.dart';
import '../helpers/pengaturan_helper.dart';

class HalamanDashboard extends StatelessWidget {
  const HalamanDashboard({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: PengaturanHelper.instance.ambang,
    builder: (context, ambang, child) => Scaffold(
      appBar: AppBar(
        title: const Text('Siaga Nusantara'),
        actions: const [ThemeToggleButton()],
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return RefreshIndicator(
            onRefresh: context.read<SensorCubit>().muatDashboard,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
              children: [
                Text(
                  'Pemantauan Sensor',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Pembacaan terbaru per jenis dari Hive'),
                const SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    StatusBadge(
                      status: StatusSiaga.dariPembacaan(state.terbaru),
                    ),
                    Text('${state.jumlah} catatan tersimpan'),
                  ],
                ),
                const SizedBox(height: 18),
                for (final jenis in JenisSensor.values) ...[
                  SensorCard(
                    jenis: jenis,
                    pembacaan: state.terbaru
                        .where((data) => data.jenisSensor == jenis)
                        .firstOrNull,
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: state.sibuk
                      ? null
                      : () async {
                          final berhasil = await context
                              .read<SensorCubit>()
                              .simulasikan();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                berhasil
                                    ? 'Data simulasi tersimpan di Hive.'
                                    : 'Data simulasi belum tersimpan.',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.sensors),
                  label: const Text('Tambah Data Simulasi'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ambang status adalah contoh untuk praktikum. Waktu mengikuti zona perangkat.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  TextButton(
                    onPressed: context.read<SensorCubit>().muatDashboard,
                    child: const Text('Muat ulang'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pembacaan'),
        onPressed: () async {
          final cubit = context.read<SensorCubit>();
          final berhasil = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => FormPembacaan(onSimpan: cubit.tambah),
          );
          if (!context.mounted || berhasil != true) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pembacaan tersimpan di Hive.')),
          );
        },
      ),
    ),
  );
}
