import 'package:flutter/material.dart';

import '../models/pembacaan_sensor.dart';
import '../models/status_siaga.dart';
import 'status_badge.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.jenis, this.pembacaan});
  final JenisSensor jenis;
  final PembacaanSensor? pembacaan;
  static IconData ikon(JenisSensor jenis) => switch (jenis) {
    JenisSensor.ketinggianAir => Icons.water_outlined,
    JenisSensor.pergeseranTanah => Icons.landscape_outlined,
    JenisSensor.curahHujan => Icons.cloud_outlined,
  };
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = pembacaan;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon(jenis), color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(jenis.label, style: theme.textTheme.titleMedium),
                ),
                if (data != null) StatusBadge(status: StatusSiaga.untuk(data)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data == null
                  ? '-- ${jenis.satuan}'
                  : '${data.nilaiTampilan} ${jenis.satuan}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(data?.lokasiPos ?? 'Belum ada pembacaan tersimpan'),
            if (data != null)
              Text(
                data.waktuTampilan,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
