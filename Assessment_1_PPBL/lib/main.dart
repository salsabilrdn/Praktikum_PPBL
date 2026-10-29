import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/app_routes.dart';
import 'state/app_state.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AgriClimaApp(),
    ),
  );
}

class AgriClimaApp extends StatelessWidget {
  const AgriClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AgriClima LSTM',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: state.modeGelap ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppRoutes.beranda,
        routes: AppRoutes.daftarRoute(),
        onUnknownRoute: AppRoutes.routeTidakDikenal,
      ),
    );
  }
}
