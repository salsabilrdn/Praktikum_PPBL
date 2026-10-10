import 'package:flutter/foundation.dart';

class FavoritModel extends ChangeNotifier {
  final Set<String> _favorit = {};

  bool isFavorit(String namaLayanan) {
    return _favorit.contains(namaLayanan);
  }

  void tandai(String namaLayanan) {
    _favorit.add(namaLayanan);
    notifyListeners();
  }

  void batalTandai(String namaLayanan) {
    _favorit.remove(namaLayanan);
    notifyListeners();
  }

  Set<String> get favorit => Set.unmodifiable(_favorit);
}
