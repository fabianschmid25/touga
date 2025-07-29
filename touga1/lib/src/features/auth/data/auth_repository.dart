// lib/src/features/auth/data/auth_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient _client;
  AuthRepository(this._client);

  /// Login: wirft eine Exception mit aussagekräftiger Fehlermeldung bei HTTP-Errors
  Future<void> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      await _client.persistTokens(
        response.data['accessToken'] as String,
        response.data['refreshToken'] as String,
      );
    } on DioException catch (e) {
      // Prüfe, ob der Server eine lesbare Fehlermeldung zurückgibt
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Login failed: $msg');
    }
  }

  /// Registrierung: ähnlich zum Login, mit Error-Handling
  Future<void> register(String email, String password, String? name) async {
    try {
      final response = await _client.dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      );
      await _client.persistTokens(
        response.data['accessToken'] as String,
        response.data['refreshToken'] as String,
      );
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Registration failed: $msg');
    }
  }

  /// Logout: löscht am Server den Refresh-Token und lokal alle gespeicherten Tokens
  Future<void> logout() async {
    try {
      await _client.dio.post('/auth/logout');
    } on DioException {
      // Ignoriere Errors beim Logout
    } finally {
      await _client.storage.deleteAll();
    }
  }
}
