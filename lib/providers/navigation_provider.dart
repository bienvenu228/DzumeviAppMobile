// lib/providers/navigation_provider.dart
import 'package:flutter_riverpod/legacy.dart';

// État de la navigation
class NavigationState {
  final int selectedIndex;
  final bool isAdminMode;

  const NavigationState({
    this.selectedIndex = 0,
    this.isAdminMode = false,
  });

  NavigationState copyWith({
    int? selectedIndex,
    bool? isAdminMode,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isAdminMode: isAdminMode ?? this.isAdminMode,
    );
  }
}

// Notifier pour gérer la navigation
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void changeTab(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void toggleAdminMode(bool isAdmin) {
    state = state.copyWith(isAdminMode: isAdmin);
  }

  void reset() {
    state = const NavigationState();
  }
}

// Provider pour la navigation
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);