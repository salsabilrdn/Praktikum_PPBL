import 'package:flutter/material.dart';

import '../pages/halaman_detail_layanan.dart';
import '../pages/halaman_riwayat_laporan.dart';
import '../pages/halaman_pengaturan.dart';
import '../pages/halaman_tentang.dart';

class AppRoutes {
  static const String detail = '/detail';
  static const String riwayat = '/riwayat';
  static const String pengaturan = '/pengaturan';
  static const String tentang = '/tentang';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case detail:
        final layanan = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => HalamanDetailLayanan(layanan: layanan),
        );

      case riwayat:
        return MaterialPageRoute(builder: (_) => const HalamanRiwayatLaporan());

      case pengaturan:
        return MaterialPageRoute(builder: (_) => const HalamanPengaturan());

      case tentang:
        return MaterialPageRoute(builder: (_) => const HalamanTentang());

      default:
        return null;
    }
  }
}
