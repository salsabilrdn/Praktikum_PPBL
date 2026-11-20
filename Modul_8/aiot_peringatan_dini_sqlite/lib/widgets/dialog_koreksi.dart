import 'package:flutter/material.dart';

import '../models/pembacaan_sensor.dart';
import 'form_pembacaan.dart';

class DialogKoreksi extends StatefulWidget {
  const DialogKoreksi({super.key, required this.data});
  final PembacaanSensor data;
  @override
  State<DialogKoreksi> createState() => _DialogKoreksiState();
}

class _DialogKoreksiState extends State<DialogKoreksi> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data.nilaiTampilan);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Koreksi Nilai'),
    scrollable: true,
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.data.jenisSensor.label} • ${widget.data.lokasiPos}'),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('edit_nilai'),
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Nilai koreksi',
              suffixText: widget.data.jenisSensor.satuan,
            ),
            validator: (value) => parseNilaiSensor(value) == null
                ? 'Isi angka 0 atau lebih.'
                : null,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, parseNilaiSensor(_controller.text));
          }
        },
        child: const Text('Simpan Koreksi'),
      ),
    ],
  );
}
