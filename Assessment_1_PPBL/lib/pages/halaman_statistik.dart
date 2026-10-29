import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widget/stat_card.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final jumlah = {
          'Kering': state.prediksi
              .where((data) => data.status == 'Kering')
              .length,
          'Optimal': state.prediksi
              .where((data) => data.status == 'Optimal')
              .length,
          'Terlalu lembap': state.prediksi
              .where((data) => data.status == 'Terlalu lembap')
              .length,
        };
        final total = state.prediksi.length;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Statistik Mikroklimat',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            StatCard(
              label: 'Total prediksi',
              value: '$total',
              icon: Icons.insights_outlined,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 20, 12),
                  child: BarChart(
                    BarChartData(
                      maxY:
                          (jumlah.values.fold<int>(
                                    0,
                                    (max, value) => value > max ? value : max,
                                  ) +
                                  1)
                              .toDouble(),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final labels = ['Kering', 'Optimal', 'Lembap'];
                              final index = value.toInt();
                              return index < labels.length
                                  ? SideTitleWidget(
                                      meta: meta,
                                      child: Text(labels[index]),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        jumlah.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: jumlah.values.elementAt(index).toDouble(),
                              width: 30,
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            for (final entry in jumlah.entries)
              ListTile(
                leading: const Icon(Icons.circle, size: 12),
                title: Text(entry.key),
                trailing: Text('${entry.value} prediksi'),
              ),
          ],
        );
      },
    );
  }
}
