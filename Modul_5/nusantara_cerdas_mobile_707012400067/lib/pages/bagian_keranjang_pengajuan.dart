import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pengajuan_cubit.dart';

class BagianKeranjangPengajuan extends StatefulWidget {
  const BagianKeranjangPengajuan({super.key});

  @override
  State<BagianKeranjangPengajuan> createState() =>
      _BagianKeranjangPengajuanState();
}

class _BagianKeranjangPengajuanState extends State<BagianKeranjangPengajuan> {
  bool sedangMengirim = false;

  Future<void> kirimSemua(List<String> daftarPengajuan) async {
    if (sedangMengirim || daftarPengajuan.isEmpty) return;

    setState(() {
      sedangMengirim = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      sedangMengirim = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar pengajuan sudah tercatat di aplikasi.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PengajuanCubit, List<String>>(
      builder: (context, daftarPengajuan) {
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
                      '${daftarPengajuan.length}',
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

              if (daftarPengajuan.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Belum ada pengajuan. Pilih layanan dan '
                    'ajukan melalui halaman detail.',
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                )
              else
                ...daftarPengajuan.map(
                  (nama) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF315A91),
                    ),
                    title: Text(nama),
                    trailing: IconButton(
                      tooltip: 'Hapus pengajuan',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: sedangMengirim
                          ? null
                          : () {
                              context.read<PengajuanCubit>().hapusPengajuan(
                                nama,
                              );
                            },
                    ),
                  ),
                ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: daftarPengajuan.isEmpty || sedangMengirim
                      ? null
                      : () => kirimSemua(daftarPengajuan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF172B4D),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD0D5DD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: sedangMengirim
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Kirim Semua Pengajuan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Total pengajuan: ${daftarPengajuan.length}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
