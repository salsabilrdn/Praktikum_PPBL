import 'package:flutter/material.dart';

class HalamanChat extends StatefulWidget {
  const HalamanChat({super.key});

  @override
  State<HalamanChat> createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  static const Color navy = Color(0xFF172B4D);
  static const Color biru = Color(0xFF315A91);
  static const Color background = Color(0xFFF4F6FA);

  final TextEditingController pesanController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> daftarPesan = [
    {
      'isi': 'Halo! Selamat datang di layanan Tanya Petugas.',
      'dariWarga': false,
      'waktu': '09.00',
    },
    {
      'isi': 'Silakan sampaikan pertanyaan atau kendala Anda.',
      'dariWarga': false,
      'waktu': '09.00',
    },
  ];

  void kirimPesan() {
    final isiPesan = pesanController.text.trim();

    if (isiPesan.isEmpty) return;

    setState(() {
      daftarPesan.add({
        'isi': isiPesan,
        'dariWarga': true,
        'waktu':
            '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:'
            '${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
      });

      pesanController.clear();
    });

    // Gulir ke pesan terbaru.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    pesanController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: navy),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanya Petugas', style: TextStyle(fontSize: 17)),
                Text('Layanan informasi warga', style: TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // DAFTAR PESAN
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: daftarPesan.length,
              itemBuilder: (context, index) {
                final pesan = daftarPesan[index];
                final bool dariWarga = pesan['dariWarga'] as bool;

                return Align(
                  alignment: dariWarga
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: dariWarga ? navy : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(dariWarga ? 14 : 0),
                        bottomRight: Radius.circular(dariWarga ? 0 : 14),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dariWarga ? 'Anda' : 'Petugas',
                          style: TextStyle(
                            color: dariWarga ? Colors.white70 : biru,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pesan['isi'] as String,
                          style: TextStyle(
                            color: dariWarga
                                ? Colors.white
                                : const Color(0xFF344054),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            pesan['waktu'] as String,
                            style: TextStyle(
                              color: dariWarga
                                  ? Colors.white60
                                  : Colors.black45,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // KOLOM INPUT PESAN
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pesanController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => kirimPesan(),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        filled: true,
                        fillColor: background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: kirimPesan,
                    style: IconButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(48, 48),
                    ),
                    icon: const Icon(Icons.send),
                    tooltip: 'Kirim pesan',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
