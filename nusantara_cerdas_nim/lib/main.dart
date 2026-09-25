import 'package:flutter/material.dart';
import 'halaman_utama.dart';

void main() {
  runApp(const NusantaraCerdas());
}

class NusantaraCerdas extends StatelessWidget {
  const NusantaraCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nusantara Cerdas',

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      home: const HalamanUtama(),
    );
  }
}