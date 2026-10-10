import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCategoryNotifier extends Notifier<int?> {
  @override
  int? build() {
    return null; // null = show all products
  }

  void selectCategory(int? id) {
    state = id;
  }

  void clearCategory() {
    state = null;
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, int?>(
  SelectedCategoryNotifier.new,
);