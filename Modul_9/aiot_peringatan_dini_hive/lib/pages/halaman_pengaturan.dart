import 'package:flutter/material.dart';

import '../models/pembacaan_sensor.dart';
import '../helpers/pengaturan_helper.dart';

class HalamanPengaturan extends StatefulWidget {
  const HalamanPengaturan({super.key});
  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  final form = GlobalKey<FormState>();
  final waspada = <JenisSensor, TextEditingController>{},
      siaga = <JenisSensor, TextEditingController>{};
  bool sibuk = false;
  @override
  void initState() {
    super.initState();
    for (final j in JenisSensor.values) {
      final b = PengaturanHelper.instance.ambang.value[j]!;
      waspada[j] = TextEditingController(text: b.waspada.toString());
      siaga[j] = TextEditingController(text: b.siaga.toString());
    }
  }

  @override
  void dispose() {
    for (final c in [...waspada.values, ...siaga.values]) {
      c.dispose();
    }
    super.dispose();
  }

  double? angka(String? s) => double.tryParse((s ?? '').replaceAll(',', '.'));
  Future<void> simpan() async {
    if (sibuk || !form.currentState!.validate()) return;
    setState(() {
      sibuk = true;
    });
    try {
      await PengaturanHelper.instance.simpanAmbang({
        for (final j in JenisSensor.values)
          j: BatasSensor(angka(waspada[j]!.text)!, angka(siaga[j]!.text)!),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ambang batas tersimpan.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ambang belum tersimpan.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          sibuk = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan Ambang Batas')),
    body: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Ambang contoh praktikum. Batas Siaga harus lebih besar daripada Waspada.',
          ),
          for (final j in JenisSensor.values) ...[
            const SizedBox(height: 20),
            Text(
              '${j.label} (${j.satuan})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    key: Key('waspada_${j.kode}'),
                    controller: waspada[j],
                    decoration: InputDecoration(
                      labelText: 'Waspada ${j.label}',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (s) {
                      final n = angka(s);
                      return n == null || !n.isFinite || n < 0
                          ? 'Angka harus 0 atau lebih.'
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: Key('siaga_${j.kode}'),
                    controller: siaga[j],
                    decoration: InputDecoration(labelText: 'Siaga ${j.label}'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (s) {
                      final n = angka(s), w = angka(waspada[j]!.text);
                      return n == null || !n.isFinite || w == null || n <= w
                          ? 'Harus lebih besar dari Waspada.'
                          : null;
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: sibuk ? null : simpan,
            child: const Text('Simpan Ambang Batas'),
          ),
          TextButton(
            onPressed: sibuk
                ? null
                : () async {
                    setState(() => sibuk = true);
                    try {
                      await PengaturanHelper.instance.reset();
                      if (!mounted) return;
                      for (final j in JenisSensor.values) {
                        waspada[j]!.text = j.batasWaspada.toString();
                        siaga[j]!.text = j.batasSiaga.toString();
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ambang belum direset.'),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => sibuk = false);
                    }
                  },
            child: const Text('Reset Ambang Batas'),
          ),
        ],
      ),
    ),
  );
}
