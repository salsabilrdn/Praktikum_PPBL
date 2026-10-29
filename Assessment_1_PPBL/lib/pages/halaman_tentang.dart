import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang AgriClima')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Tujuan Aplikasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'AgriClima LSTM membantu memantau kondisi mikroklimat dan memberikan '
            'prediksi untuk mendukung pengelolaan tanaman secara lebih tepat.',
          ),
          SizedBox(height: 24),
          Text('Lokasi Pemantauan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.location_on_outlined),
            title: Text('Petak 1'),
            subtitle: Text('Lokasi pemantauan mikroklimat petak 1'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.location_on_outlined),
            title: Text('Petak 2'),
            subtitle: Text('Lokasi pemantauan mikroklimat petak 2'),
          ),
          SizedBox(height: 12),
          Text('Parameter Mikroklimat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.thermostat_outlined),
            title: Text('Suhu udara'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.water_drop_outlined),
            title: Text('Kelembapan udara'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.grass_outlined),
            title: Text('Kelembapan tanah'),
          ),
        ],
      ),
    );
  }
}
