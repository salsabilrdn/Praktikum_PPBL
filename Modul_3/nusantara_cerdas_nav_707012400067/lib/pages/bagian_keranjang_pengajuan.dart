import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class BagianKeranjangPengajuan extends StatefulWidget {
  const BagianKeranjangPengajuan({super.key});

  @override
  State<BagianKeranjangPengajuan> createState() =>
      _BagianKeranjangPengajuanState();
}

class _BagianKeranjangPengajuanState extends State<BagianKeranjangPengajuan> {
  bool sedangMengirim = false;

  Future<void> kirimSemua() async {
    if (sedangMengirim) return;

    final model = context.read<PengajuanModel>();

    if (model.keranjang.isEmpty) return;

    setState(() {
      sedangMengirim = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    model.kirimSemuaPengajuan();

    setState(() {
      sedangMengirim = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua pengajuan berhasil dikirim.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PengajuanModel>(
      builder: (context, model, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF315A91),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Keranjang Pengajuan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color(0xFFE8EDF6),
                    child: Text(
                      '${model.totalKeranjang}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (model.keranjang.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Belum ada layanan di keranjang. '
                    'Pilih layanan yang ingin diajukan.',
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                )
              else
                ...model.keranjang.map(
                  (nama) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF315A91),
                    ),
                    title: Text(nama),
                    trailing: IconButton(
                      tooltip: 'Hapus dari keranjang',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: sedangMengirim
                          ? null
                          : () {
                              model.hapusDariKeranjang(nama);
                            },
                    ),
                  ),
                ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: model.keranjang.isEmpty || sedangMengirim
                      ? null
                      : kirimSemua,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF172B4D),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD0D5DD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: sedangMengirim
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
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
                          'Kirim Semua Pengajuan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pengajuan terkirim: ${model.totalPengajuan}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
