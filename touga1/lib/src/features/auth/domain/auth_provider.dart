// lib/src/features/auth/domain/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

/// Provider für DioClient (global verfügbar)
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

/// Provider für AuthRepository, nutzt den DioClient
final authRepoProvider = Provider<AuthRepository>((ref) {
  final client = ref.read(dioClientProvider);
  return AuthRepository(client);
});

/// StateNotifier-Provider für Authentifizierung
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepoProvider)),
);

/// StateNotifier für Auth-Logik (Login, Register, Logout, Dev-Auto-Login)
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AuthState(AuthStatus.unknown)) {
    _autoLoginAdmin();
  }

  /// Auto-Login als Admin für Dev-Testing
  Future<void> _autoLoginAdmin() async {
    debugPrint('🔄 AuthNotifier: Auto-Login als Admin startet...');
    state = AuthState(AuthStatus.loading);
    try {
      await _repo.login('admin@example.com', 'AdminPass123');
      state = AuthState(AuthStatus.authenticated, email: 'admin@example.com');
      debugPrint('✅ AuthNotifier: Auto-Login erfolgreich');
    } catch (e, st) {
      state = AuthState(AuthStatus.unauthenticated);
      debugPrint('❌ AuthNotifier: Auto-Login fehlgeschlagen – $e');
      debugPrintStack(stackTrace: st);
    }
  }

  /// Registrierung (bleibt unverändert)
  Future<void> register(String email, String password, String? name) async {
    debugPrint('🔄 AuthNotifier: register attempt for $email');
    state = AuthState(AuthStatus.loading);
    try {
      await _repo.register(email, password, name);
      state = AuthState(AuthStatus.authenticated, email: email);
      debugPrint('✅ AuthNotifier: register success for $email');
    } catch (e, st) {
      state = AuthState(AuthStatus.unauthenticated);
      debugPrint('❌ AuthNotifier: register failed for $email – $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  /// Login (bleibt für manuelles Login, wenn nötig)
  Future<void> login(String email, String password) async {
    debugPrint('🔑 AuthNotifier: login attempt for $email');
    state = AuthState(AuthStatus.loading);
    try {
      await _repo.login(email, password);
      state = AuthState(AuthStatus.authenticated, email: email);
      debugPrint('✅ AuthNotifier: login success for $email');
    } catch (e, st) {
      state = AuthState(AuthStatus.unauthenticated);
      debugPrint('❌ AuthNotifier: login failed for $email – $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    debugPrint('🚪 AuthNotifier: logout initiated');
    await _repo.logout();
    state = AuthState(AuthStatus.unauthenticated);
    debugPrint('🔄 AuthNotifier: status -> unauthenticated');
  }
}
