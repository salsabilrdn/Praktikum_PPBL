import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/pengajuan_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  @override
  Widget build(BuildContext context) {
    // Mengambil data pengajuan melalui Provider
    final model = context.watch<PengajuanModel>();
    final daftarPengajuan = model.pengajuan;

    // Menghitung jumlah pengajuan untuk setiap kategori
    final Map<String, int> statistik = {};

    for (final pengajuan in daftarPengajuan) {
      statistik.update(
        pengajuan.kategori,
        (jumlah) => jumlah + 1,
        ifAbsent: () => 1,
      );
    }

    final kategori = statistik.keys.toList();
    final jumlah = statistik.values.toList();

    // Nilai maksimum sumbu Y mengikuti data
    final int jumlahMaksimum = jumlah.isEmpty
        ? 5
        : jumlah.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Layanan'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Pengajuan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jumlah pengajuan berdasarkan bidang layanan.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Ringkasan jumlah pengajuan
            Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: biru,
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
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Diagram Batang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Diagram batang menggunakan fl_chart
            if (statistik.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.bar_chart, size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada data pengajuan.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Kirim pengajuan melalui formulir layanan '
                      'untuk menampilkan statistik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BarChart(
                  BarChartData(
                    maxY: (jumlahMaksimum + 1).toDouble(),
                    minY: 0,
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      kategori.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: jumlah[index].toDouble(),
                            color: biru,
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
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Kategori Layanan',
                          style: TextStyle(fontSize: 11),
                        ),
                        axisNameSize: 24,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();

                            if (index < 0 || index >= kategori.length) {
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
                                style: const TextStyle(fontSize: 10),
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

            // Rincian jumlah pengajuan
            if (statistik.isNotEmpty) ...[
              const Text(
                'Rincian Pengajuan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...statistik.entries.map(
                (entry) => Card(
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.folder_outlined, color: biru),
                    title: Text(entry.key),
                    trailing: Text(
                      '${entry.value} pengajuan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: navy,
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
  }
}
