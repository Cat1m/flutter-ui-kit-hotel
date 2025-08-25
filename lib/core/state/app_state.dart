import 'package:flutter/foundation.dart';

class AppState {
  static final favorites = ValueNotifier<Set<String>>(<String>{});
  static void toggleFav(String id) {
    final s = Set<String>.from(favorites.value);
    s.contains(id) ? s.remove(id) : s.add(id);
    favorites.value = s;
  }

  static bool isFav(String id) => favorites.value.contains(id);
}
