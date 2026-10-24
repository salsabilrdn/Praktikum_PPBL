
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/favorit_cubit.dart';
import 'cubit/pengajuan_cubit.dart';
import 'navigation/kerangka_navigasi.dart';
import 'navigation/app_routes.dart';
import 'pages/halaman_route_tidak_dikenal.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<FavoritCubit>(
          create: (_) => FavoritCubit(),
        ),
        BlocProvider<PengajuanCubit>(
          create: (_) => PengajuanCubit(),
        ),
      ],
      child: const NusantaraCerdasApp(),
    ),
  );
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF172B4D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const KerangkaNavigasi(),
      onGenerateRoute: AppRoutes.generateRoute,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const HalamanRouteTidakDikenal(),
        );
      },
    );
  }
}
