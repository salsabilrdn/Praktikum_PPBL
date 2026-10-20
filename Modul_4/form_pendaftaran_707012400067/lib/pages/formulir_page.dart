import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pendaftar_model.dart';
import 'statistik_page.dart';

class FormulirPage extends StatefulWidget {
  const FormulirPage({super.key});

  @override
  State<FormulirPage> createState() => _FormulirPageState();
}

class _FormulirPageState extends State<FormulirPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();

  bool setujuSyarat = false;
  String? sesiTerpilih;
  bool sedangMengirim = false;

  bool get formLengkap =>
      namaController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      setujuSyarat &&
      sesiTerpilih != null;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> kirimFormulir() async {
    setState(() => sedangMengirim = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    context.read<PendaftarModel>().tambah(
      Pendaftar(
        nama: namaController.text,
        email: emailController.text,
        sesi: sesiTerpilih!,
      ),
    );

    setState(() => sedangMengirim = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pendaftaran berhasil dikirim')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Pendaftaran')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            namaController.clear();
            emailController.clear();
            setujuSyarat = false;
            sesiTerpilih = null;
          });
        },
        tooltip: 'Bersihkan formulir',
        child: const Icon(Icons.refresh),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detail-kegiatan');
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kegiatan: Seminar Teknologi Mobile'),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Seminar Teknologi Mobile'),
                  subtitle: const Text(
                    'Ketuk untuk detail, tahan untuk info singkat',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: namaController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: setujuSyarat,
              title: const Text(
                'Saya menyetujui syarat dan ketentuan kegiatan',
              ),
              onChanged: (nilai) {
                setState(() {
                  setujuSyarat = nilai ?? false;
                });
              },
            ),

            ...['Pagi', 'Siang', 'Sore'].map((sesi) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: Text('Sesi $sesi'),
                value: sesi,
                groupValue: sesiTerpilih,
                onChanged: (nilai) {
                  setState(() {
                    sesiTerpilih = nilai;
                  });
                },
              );
            }),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (formLengkap && !sedangMengirim)
                    ? kirimFormulir
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: sedangMengirim
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kirim Pendaftaran'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StatistikPage()),
                  );
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('Lihat Statistik'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
