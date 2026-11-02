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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          Text(
            'Preferensi Aplikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Atur pengalaman penggunaan aplikasi Nusantara Cerdas.',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 1,
            color: colors.surface,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.notifications_active_outlined,
                    color: colors.primary,
                  ),
                  title: const Text(
                    'Notifikasi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Terima informasi dan pemberitahuan layanan.',
                  ),
                  value: notifikasiAktif,
                  activeTrackColor: colors.primary,
                  onChanged: (value) {
                    setState(() {
                      notifikasiAktif = value;
                    });
                  },
                ),

                const Divider(height: 1),

                SwitchListTile(
                  secondary: Icon(
                    Icons.data_saver_on_outlined,
                    color: colors.primary,
                  ),
                  title: const Text(
                    'Mode Hemat Data',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Menghemat penggunaan data internet.'),
                  value: modeHematData,
                  activeTrackColor: colors.primary,
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
            color: colors.surface,
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.language, color: colors.primary),
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
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pengaturan ini merupakan preferensi '
                    'lokal pada aplikasi.',
                    style: TextStyle(color: colors.onSurface, fontSize: 13),
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
