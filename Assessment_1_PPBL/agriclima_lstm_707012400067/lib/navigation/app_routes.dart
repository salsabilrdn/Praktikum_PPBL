import 'package:flutter/material.dart';

import '../pages/halaman_input_prediksi.dart';
import '../pages/halaman_statistik.dart';
import '../pages/halaman_tentang.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  static const String beranda = '/';
  static const String tentang = '/tentang';
  static const String inputPrediksi = '/input-prediksi';
  static const String statistik = '/statistik';

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (_) => const KerangkaNavigasi(),
      tentang: (_) => const HalamanTentang(),
      inputPrediksi: (_) => const HalamanInputPrediksi(),
      statistik: (_) => const HalamanStatistik(),
    };
  }

  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Tidak Ditemukan')),
        body: Center(child: Text('Route ${settings.name} belum terdaftar.')),
      ),
    );
  }
}
