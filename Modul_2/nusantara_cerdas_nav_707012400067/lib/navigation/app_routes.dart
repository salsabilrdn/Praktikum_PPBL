import 'package:flutter/material.dart';

// Import halaman yang menggunakan Named Routes
import '../pages/halaman_detail_layanan.dart';
import '../pages/halaman_riwayat_laporan.dart';
import '../pages/halaman_pengaturan.dart';
import '../pages/halaman_tentang.dart';

class AppRoutes {
  // Nama-nama route aplikasi
  static const String detail = '/detail';
  static const String riwayat = '/riwayat';
  static const String pengaturan = '/pengaturan';
  static const String tentang = '/tentang';

  // Mengatur halaman berdasarkan nama route
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
        // Route tidak dikenal ditangani oleh onUnknownRoute
        return null;
    }
  }
}
