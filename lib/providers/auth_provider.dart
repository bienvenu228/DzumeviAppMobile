// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/admin.dart';
import '../services/auth_service.dart';

class AuthState {
  final Admin? admin;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.admin,
    this.isLoading = false,
    this.error,
  });

  bool get isAdminLoggedIn => admin != null;

  AuthState copyWith({
    Admin? admin,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      admin: admin ?? this.admin,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> loginAdmin(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final admin = await _authService.loginAdmin(email, password);
      state = state.copyWith(
        admin: admin,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Vérifier si un token existe au démarrage
  Future<void> checkInitialAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final token = await _authService.getToken();
      final userType = await _authService.getUserType();
      
      if (token != null && userType == 'admin') {
        // Ici vous pourriez recharger les données admin si nécessaire
        state = state.copyWith(isLoading: false);
      } else {
        state = const AuthState();
      }
    } catch (e) {
      state = const AuthState();
    }
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);