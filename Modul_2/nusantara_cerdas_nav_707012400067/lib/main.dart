import 'package:flutter/material.dart';

import 'navigation/kerangka_navigasi.dart';
import 'navigation/app_routes.dart';
import 'pages/halaman_route_tidak_dikenal.dart';

void main() {
  runApp(const NusantaraCerdasApp());
}

class NusantaraCerdasApp extends StatelessWidget {
  const NusantaraCerdasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Cerdas',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF172B4D)),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),

      // Halaman pertama yang ditampilkan
      home: const KerangkaNavigasi(),

      // Mengatur Named Routes
      onGenerateRoute: AppRoutes.generateRoute,

      // Menangani route yang tidak dikenal
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return const HalamanRouteTidakDikenal();
          },
        );
      },
    );
  }
}
