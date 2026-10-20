import 'package:flutter/material.dart';

class HalamanPengaturan extends StatefulWidget {
  const HalamanPengaturan({super.key});

  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  bool notifikasiAktif = true;
  bool modeHematData = false;

  static const Color navy = Color(0xFF172B4D);
  static const Color background = Color(0xFFF4F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Pengaturan Kota',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: navy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preferensi Aplikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Atur pengalaman penggunaan aplikasi Nusantara Cerdas.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 1,
            color: Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_active_outlined,
                    color: navy,
                  ),
                  title: const Text(
                    'Notifikasi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Terima informasi dan pemberitahuan layanan.',
                  ),
                  value: notifikasiAktif,
                  activeTrackColor: navy,
                  onChanged: (value) {
                    setState(() {
                      notifikasiAktif = value;
                    });
                  },
                ),

                const Divider(height: 1),

                SwitchListTile(
                  secondary: const Icon(
                    Icons.data_saver_on_outlined,
                    color: navy,
                  ),
                  title: const Text(
                    'Mode Hemat Data',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Menghemat penggunaan data internet.'),
                  value: modeHematData,
                  activeTrackColor: navy,
                  onChanged: (value) {
                    setState(() {
                      modeHematData = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Card(
            color: Colors.white,
            elevation: 1,
            child: const ListTile(
              leading: Icon(Icons.language, color: navy),
              title: Text(
                'Bahasa Aplikasi',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Bahasa Indonesia'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: navy),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pengaturan ini merupakan preferensi '
                    'lokal pada aplikasi.',
                    style: TextStyle(color: navy, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
