import 'package:flutter/material.dart';

class PanelLaporanWarga extends StatefulWidget {
  const PanelLaporanWarga({super.key});

  @override
  State<PanelLaporanWarga> createState() =>
      _PanelLaporanWargaState();
}

class _PanelLaporanWargaState extends State<PanelLaporanWarga> {
  int jumlahLaporan = 0;

  void laporanMasuk() {
    setState(() {
      jumlahLaporan++;
    });
  }

  void laporanSelesai() {
    setState(() {
      if (jumlahLaporan > 0) {
        jumlahLaporan--;
      }
    });
  }

  void resetHarian() {
    setState(() {
      jumlahLaporan = 0;
    });
  }

  String get statusPelayanan {
    if (jumlahLaporan < 5) {
      return 'Pelayanan Lancar';
    } else if (jumlahLaporan <= 10) {
      return 'Pelayanan Sibuk';
    } else {
      return 'Perlu Penambahan Petugas';
    }
  }

  Color get warnaStatus {
    if (jumlahLaporan < 5) {
      return Colors.green;
    } else if (jumlahLaporan <= 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 245,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Jumlah laporan
              Row(
                children: [
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      'Jumlah Laporan',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Text(
                    '$jumlahLaporan',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Status pelayanan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: warnaStatus.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusPelayanan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: warnaStatus,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: laporanMasuk,
                      icon: const Icon(Icons.add),
                      label: const Text('Laporan Masuk'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: laporanSelesai,
                      icon: const Icon(Icons.remove),
                      label: const Text('Laporan Selesai'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: resetHarian,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Harian'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}