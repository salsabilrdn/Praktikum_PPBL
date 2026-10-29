import 'package:flutter/material.dart';

import '../state/app_state.dart';

class HalamanInputPrediksi extends StatefulWidget {
  const HalamanInputPrediksi({super.key});

  @override
  State<HalamanInputPrediksi> createState() => _HalamanInputPrediksiState();
}

class _HalamanInputPrediksiState extends State<HalamanInputPrediksi> {
  final _formKey = GlobalKey<FormState>();
  final _suhuController = TextEditingController();
  final _kelembapanUdaraController = TextEditingController();
  final _kelembapanTanahController = TextEditingController();
  final _namaPetugasController = TextEditingController();

  int _petakTerpilih = 1;
  String? _namaTanaman;
  bool _dataSudahBenar = false;

  @override
  void dispose() {
    _suhuController.dispose();
    _kelembapanUdaraController.dispose();
    _kelembapanTanahController.dispose();
    _namaPetugasController.dispose();
    super.dispose();
  }

  String? _validasiAngka(
    String? nilai, {
    required String label,
    required bool wajibRentang,
  }) {
    if (nilai == null || nilai.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    final angka = double.tryParse(nilai.trim());
    if (angka == null) {
      return '$label harus berupa angka.';
    }
    if (wajibRentang && (angka < 0 || angka > 100)) {
      return '$label harus berada di antara 0-100.';
    }
    return null;
  }

  String _tentukanStatus(double kelembapanTanah) {
    if (kelembapanTanah < 40) {
      return 'Kering';
    }
    if (kelembapanTanah <= 70) {
      return 'Optimal';
    }
    return 'Terlalu lembap';
  }

  String _catatanPerawatan(String tanaman) {
    switch (tanaman) {
      case 'Padi':
        return 'Jaga genangan air 2-5 cm pada fase vegetatif dan keringkan '
            'lahan menjelang panen.';
      case 'Jagung':
        return 'Siram saat tanah mulai kering dan hindari genangan di sekitar '
            'perakaran.';
      case 'Cabai':
        return 'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada '
            'pagi atau sore hari.';
      default:
        return 'Sesuaikan perawatan dengan kondisi mikroklimat tanaman.';
    }
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate() || !_dataSudahBenar) {
      return;
    }

    final suhu = double.parse(_suhuController.text.trim());
    final kelembapanUdara =
        double.parse(_kelembapanUdaraController.text.trim());
    final kelembapanTanah =
        double.parse(_kelembapanTanahController.text.trim());
    final status = _tentukanStatus(kelembapanTanah);
    final catatan = _catatanPerawatan(_namaTanaman!);

    final dikonfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Data'),
        content: Text(
          'Petak $_petakTerpilih - $_namaTanaman\n'
          'Suhu: $suhu °C\n'
          'Kelembapan udara: $kelembapanUdara%\n'
          'Kelembapan tanah: $kelembapanTanah%\n\n'
          'Status: $status\n'
          'Catatan: $catatan',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Periksa lagi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (dikonfirmasi == true && mounted) {
      Navigator.pop(
        context,
        PrediksiData(
          petak: _petakTerpilih,
          tanaman: _namaTanaman!,
          suhu: suhu,
          kelembapanUdara: kelembapanUdara,
          kelembapanTanah: kelembapanTanah,
          petugas: _namaPetugasController.text.trim(),
          status: status,
          catatan: catatan,
          waktu: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Prediksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Data Mikroklimat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Lengkapi data untuk mendapatkan status mikroklimat.'),
            const SizedBox(height: 24),
            const Text('Petak',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Card(
              child: RadioGroup<int>(
                groupValue: _petakTerpilih,
                onChanged: (nilai) {
                  if (nilai != null) {
                    setState(() => _petakTerpilih = nilai);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<int>(value: 1, title: Text('Petak 1')),
                    RadioListTile<int>(value: 2, title: Text('Petak 2')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _namaTanaman,
              decoration: const InputDecoration(
                labelText: 'Nama tanaman',
                border: OutlineInputBorder(),
              ),
              items: ['Padi', 'Jagung', 'Cabai']
                  .map((tanaman) => DropdownMenuItem(
                        value: tanaman,
                        child: Text(tanaman),
                      ))
                  .toList(),
              validator: (nilai) =>
                  nilai == null ? 'Nama tanaman wajib dipilih.' : null,
              onChanged: (nilai) => setState(() => _namaTanaman = nilai),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _suhuController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi suhu udara',
                suffixText: '°C',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) => _validasiAngka(
                nilai,
                label: 'Suhu udara',
                wajibRentang: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kelembapanUdaraController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Kelembapan udara',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) => _validasiAngka(
                nilai,
                label: 'Kelembapan udara',
                wajibRentang: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kelembapanTanahController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Kelembapan tanah',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) => _validasiAngka(
                nilai,
                label: 'Kelembapan tanah',
                wajibRentang: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaPetugasController,
              decoration: const InputDecoration(
                labelText: 'Nama petugas',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) => nilai == null || nilai.trim().isEmpty
                  ? 'Nama petugas wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _dataSudahBenar,
              title: const Text('Data sudah benar'),
              onChanged: (nilai) =>
                  setState(() => _dataSudahBenar = nilai ?? false),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _dataSudahBenar ? _simpanData : null,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
