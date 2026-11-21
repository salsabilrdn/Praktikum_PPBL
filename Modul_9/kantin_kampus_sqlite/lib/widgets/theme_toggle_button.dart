import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});
  @override
  Widget build(BuildContext context) {
    final gelap = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return IconButton(
      tooltip: gelap ? 'Mode terang' : 'Mode gelap',
      icon: Icon(gelap ? Icons.light_mode : Icons.dark_mode),
      onPressed: () async {
        try {
          await context.read<ThemeCubit>().toggle();
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tema belum berhasil disimpan.')),
            );
          }
        }
      },
    );
  }
}
