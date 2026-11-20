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
      onPressed: context.read<ThemeCubit>().toggle,
      icon: Icon(gelap ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
