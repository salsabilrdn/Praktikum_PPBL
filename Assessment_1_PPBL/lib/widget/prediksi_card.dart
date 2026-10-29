import 'package:flutter/material.dart';

import '../state/app_state.dart';

class PrediksiCard extends StatelessWidget {
  const PrediksiCard({required this.data, super.key});

  final PrediksiData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Petak ${data.petak} - ${data.tanaman}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(data.status),
                  backgroundColor: colors.secondaryContainer,
                ),
              ],
            ),
            Text(
              '${data.waktu.day.toString().padLeft(2, '0')}/'
              '${data.waktu.month.toString().padLeft(2, '0')}/'
              '${data.waktu.year} '
              '${data.waktu.hour.toString().padLeft(2, '0')}:'
              '${data.waktu.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Suhu: ${data.suhu.toStringAsFixed(1)} °C  |  '
              'Udara: ${data.kelembapanUdara.toStringAsFixed(1)}%  |  '
              'Tanah: ${data.kelembapanTanah.toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 8),
            Text('Petugas: ${data.petugas}'),
            const SizedBox(height: 8),
            Text('Catatan: ${data.catatan}'),
          ],
        ),
      ),
    );
  }
}
