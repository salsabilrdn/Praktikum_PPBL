import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/pengaturan_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit()
    : super(
        PengaturanHelper.instance.temaGelap ? ThemeMode.dark : ThemeMode.light,
      );
  Future<void> ubah(bool gelap) async {
    await PengaturanHelper.instance.simpanTema(gelap);
    if (!isClosed) emit(gelap ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggle() => ubah(state != ThemeMode.dark);
  Future<void> reset() async {
    await PengaturanHelper.instance.resetSemua();
    if (!isClosed) emit(ThemeMode.light);
  }
}
