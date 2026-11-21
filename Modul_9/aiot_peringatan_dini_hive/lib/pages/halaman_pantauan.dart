import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../widgets/form_pembacaan.dart';

class HalamanPantauan extends StatelessWidget {
  const HalamanPantauan({super.key});

  @override
  Widget build(BuildContext context) => FormPembacaan(
    sebagaiHalaman: true,
    onSimpan: context.read<SensorCubit>().tambah,
  );
}
