import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritCubit extends Cubit<Set<String>> {
  FavoritCubit() : super(<String>{});

  void tandai(String namaLayanan) {
    emit({...state, namaLayanan});
  }

  void batalTandai(String namaLayanan) {
    emit(state.where((nama) => nama != namaLayanan).toSet());
  }

  bool isFavorit(String namaLayanan) {
    return state.contains(namaLayanan);
  }
}
