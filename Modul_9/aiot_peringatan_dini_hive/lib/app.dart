import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/sensor_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'helpers/hive_helper.dart';
import 'pages/kerangka_utama.dart';
import 'theme/app_theme.dart';

class AiotApp extends StatelessWidget {
  const AiotApp({super.key, this.database});
  final HiveHelper? database;
  @override
  Widget build(BuildContext context) => RepositoryProvider<HiveHelper>.value(
    value: database ?? HiveHelper.instance,
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SensorCubit(context.read<HiveHelper>())..muatDashboard(),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Siaga Nusantara',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: const KerangkaUtama(),
        ),
      ),
    ),
  );
}
