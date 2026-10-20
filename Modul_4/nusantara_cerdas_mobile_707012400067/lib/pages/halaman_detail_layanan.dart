import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class HalamanDetailLayanan extends StatefulWidget {
  final Map<String, dynamic> layanan;

  const HalamanDetailLayanan({super.key, required this.layanan});

  @override
  State<HalamanDetailLayanan> createState() => _HalamanDetailLayananState();
}

class _HalamanDetailLayananState extends State<HalamanDetailLayanan> {
  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);

  final TextEditingController namaController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  bool setujuDataPribadi = false;
  bool sedangMengirim = false;
  String? sesiTerpilih;

  bool get formulirValid {
    return namaController.text.trim().isNotEmpty &&
        emailController.text.trim().contains('@') &&
        setujuDataPribadi &&
        sesiTerpilih != null;
  }

  Future<void> kirimPengajuan() async {
    if (!formulirValid || sedangMengirim) return;

    setState(() {
      sedangMengirim = true;
    });

    // Simulasi proses pengiriman.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final model = context.read<PengajuanModel>();

    model.tambahPengajuan(
      Pengajuan(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        kategori: (widget.layanan['nama'] ?? 'Layanan').toString(),
        sesi: sesiTerpilih!,
      ),
    );

    setState(() {
      sedangMengirim = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nama = (widget.layanan['nama'] ?? 'Nama Layanan').toString();

    final ikon = widget.layanan['ikon'];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Detail Layanan'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFORMASI DETAIL LAYANAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFE8EDF6),
                    child: Icon(
                      ikon is IconData ? ikon : Icons.miscellaneous_services,
                      color: biru,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    nama,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Instansi Penanggung Jawab',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (widget.layanan['instansi'] ?? '-').toString(),
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Jam Operasional',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (widget.layanan['jam'] ?? '-').toString(),
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Deskripsi Layanan',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (widget.layanan['detail'] ??
                            widget.layanan['deskripsi'] ??
                            '-')
                        .toString(),
                    style: const TextStyle(
                      color: Color(0xFF475467),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FORMULIR PENGAJUAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulir Pengajuan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // NAMA LENGKAP
                  const Text(
                    'Nama Lengkap',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: namaController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama lengkap',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 18),

                  // EMAIL
                  const Text(
                    'Alamat Email',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'contoh@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText:
                          emailController.text.trim().isNotEmpty &&
                              !emailController.text.trim().contains('@')
                          ? 'Email harus mengandung karakter @'
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 12),

                  // PERSETUJUAN DATA PRIBADI
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'Saya menyetujui penggunaan data pribadi.',
                      style: TextStyle(fontSize: 13),
                    ),
                    value: setujuDataPribadi,
                    onChanged: (value) {
                      setState(() {
                        setujuDataPribadi = value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // PILIHAN SESI
                  const Text(
                    'Sesi Kunjungan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Pagi'),
                    value: 'Pagi',
                    groupValue: sesiTerpilih,
                    onChanged: (value) {
                      setState(() {
                        sesiTerpilih = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Siang'),
                    value: 'Siang',
                    groupValue: sesiTerpilih,
                    onChanged: (value) {
                      setState(() {
                        sesiTerpilih = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sore'),
                    value: 'Sore',
                    groupValue: sesiTerpilih,
                    onChanged: (value) {
                      setState(() {
                        sesiTerpilih = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // TOMBOL KIRIM
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: formulirValid && !sedangMengirim
                          ? kirimPengajuan
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFCBD2DE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: sedangMengirim
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Mengirim pengajuan...'),
                              ],
                            )
                          : const Text(
                              'Kirim Pengajuan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
