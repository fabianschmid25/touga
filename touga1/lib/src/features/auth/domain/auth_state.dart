// lib/src/features/auth/domain/auth_state.dart

/// Mögliche Stati des Auth‑Flows
enum AuthStatus { unknown, loading, unauthenticated, authenticated }

/// Zustand des AuthProviders
class AuthState {
  final AuthStatus status;
  final String? email;
  AuthState(this.status, {this.email});
}
