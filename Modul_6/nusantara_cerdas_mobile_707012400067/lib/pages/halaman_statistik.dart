
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../cubit/pengajuan_cubit.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  static const Color biru = Color(0xFF315A91);

  String kategoriLayanan(String nama) {
    switch (nama) {
      case 'Izin Usaha':
      case 'Izin Bangunan':
      case 'Surat Domisili':
        return 'Perizinan';

      case 'Pendaftaran Puskesmas':
      case 'Jadwal Imunisasi':
      case 'Layanan Kesehatan Warga':
        return 'Kesehatan';

      case 'Informasi Transportasi':
      case 'Pengaduan Jalan':
      case 'Informasi Lalu Lintas':
        return 'Transportasi';

      default:
        return 'Lainnya';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<PengajuanCubit, List<String>>(
      builder: (context, daftarPengajuan) {
        final Map<String, int> statistik = {};

        for (final nama in daftarPengajuan) {
          final kategori = kategoriLayanan(nama);

          statistik.update(
            kategori,
            (jumlah) => jumlah + 1,
            ifAbsent: () => 1,
          );
        }

        final kategori = statistik.keys.toList();
        final jumlah = statistik.values.toList();

        final int jumlahMaksimum = jumlah.isEmpty
            ? 5
            : jumlah.reduce((a, b) => a > b ? a : b);

        final warnaGrafik = colors.primary;
        final warnaLabel = colors.onSurfaceVariant;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistik Layanan'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik Pengajuan',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jumlah pengajuan berdasarkan bidang layanan.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 40,
                          color: warnaGrafik,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Total Pengajuan',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Text(
                          '${daftarPengajuan.length}',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Diagram Batang',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (statistik.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 56,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada data pengajuan.',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ajukan layanan melalui halaman detail '
                          'untuk menampilkan statistik.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 320,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: (jumlahMaksimum + 1).toDouble(),
                        minY: 0,
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: colors.outlineVariant,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(
                          kategori.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: jumlah[index].toDouble(),
                                color: warnaGrafik,
                                width: 24,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: warnaLabel,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text(
                              'Kategori Layanan',
                              style: TextStyle(
                                fontSize: 11,
                                color: warnaLabel,
                              ),
                            ),
                            axisNameSize: 24,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();

                                if (index < 0 ||
                                    index >= kategori.length) {
                                  return const SizedBox.shrink();
                                }

                                String nama = kategori[index];

                                if (nama.length > 12) {
                                  nama = '${nama.substring(0, 10)}...';
                                }

                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    nama,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: warnaLabel,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                if (statistik.isNotEmpty) ...[
                  Text(
                    'Rincian Pengajuan',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...statistik.entries.map(
                    (entry) => Card(
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(
                          Icons.folder_outlined,
                          color: warnaGrafik,
                        ),
                        title: Text(entry.key),
                        trailing: Text(
                          '${entry.value} pengajuan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
