import 'package:flutter/material.dart';

import '../models/pembacaan_sensor.dart';

double? parseNilaiSensor(String? teks) {
  final nilai = double.tryParse((teks ?? '').trim().replaceAll(',', '.'));
  return nilai != null && nilai.isFinite && nilai >= 0 ? nilai : null;
}

class FormPembacaan extends StatefulWidget {
  const FormPembacaan({
    super.key,
    required this.onSimpan,
    this.sebagaiHalaman = false,
  });
  final Future<bool> Function(PembacaanSensor) onSimpan;
  final bool sebagaiHalaman;
  @override
  State<FormPembacaan> createState() => _FormPembacaanState();
}

class _FormPembacaanState extends State<FormPembacaan> {
  final _form = GlobalKey<FormState>();
  final _nilai = TextEditingController();
  final _lokasi = TextEditingController();
  JenisSensor _jenis = JenisSensor.ketinggianAir;
  bool _sibuk = false;
  String? _error;
  @override
  void dispose() {
    _nilai.dispose();
    _lokasi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_sibuk || !_form.currentState!.validate()) return;
    setState(() {
      _sibuk = true;
      _error = null;
    });
    final berhasil = await widget.onSimpan(
      PembacaanSensor(
        jenisSensor: _jenis,
        nilai: parseNilaiSensor(_nilai.text)!,
        lokasiPos: _lokasi.text.trim(),
        waktu: DateTime.now().toUtc(),
      ),
    );
    if (!mounted) return;
    if (berhasil) {
      if (widget.sebagaiHalaman) {
        FocusScope.of(context).unfocus();
        _form.currentState!.reset();
        _nilai.clear();
        _lokasi.clear();
        setState(() => _sibuk = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pembacaan tersimpan di Hive.')),
        );
      } else {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        _sibuk = false;
        _error = 'Belum tersimpan. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isiForm = Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<JenisSensor>(
            initialValue: _jenis,
            decoration: const InputDecoration(labelText: 'Jenis sensor'),
            items: JenisSensor.values
                .map(
                  (jenis) =>
                      DropdownMenuItem(value: jenis, child: Text(jenis.label)),
                )
                .toList(),
            onChanged: _sibuk
                ? null
                : (jenis) => setState(() => _jenis = jenis!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('input_nilai'),
            controller: _nilai,
            enabled: !_sibuk,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Nilai sensor',
              suffixText: _jenis.satuan,
            ),
            validator: (value) => parseNilaiSensor(value) == null
                ? 'Isi angka 0 atau lebih.'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('input_lokasi'),
            controller: _lokasi,
            enabled: !_sibuk,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Lokasi pos',
              hintText: 'Contoh: Pos Dayeuhkolot',
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Lokasi wajib diisi.'
                : null,
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
    final tombolSimpan = FilledButton(
      onPressed: _sibuk ? null : _simpan,
      child: Text(
        _sibuk
            ? 'Menyimpan...'
            : widget.sebagaiHalaman
            ? 'Simpan Pembacaan'
            : 'Simpan',
      ),
    );
    return PopScope(
      canPop: !_sibuk,
      child: widget.sebagaiHalaman
          ? Scaffold(
              appBar: AppBar(title: const Text('Pantauan Sensor')),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Masukkan pembacaan dari pos pemantauan. Data yang disimpan akan muncul di Sensor dan Riwayat.',
                  ),
                  const SizedBox(height: 24),
                  isiForm,
                  const SizedBox(height: 16),
                  tombolSimpan,
                ],
              ),
            )
          : AlertDialog(
              title: const Text('Tambah Pembacaan'),
              scrollable: true,
              content: SizedBox(width: 400, child: isiForm),
              actions: [
                TextButton(
                  onPressed: _sibuk ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                tombolSimpan,
              ],
            ),
    );
  }
}
