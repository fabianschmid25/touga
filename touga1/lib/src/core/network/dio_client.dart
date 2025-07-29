// lib/src/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // für debugPrint
import '../storage/secure_storage.dart';
import '../utils/constants.dart';

class DioClient {
  final Dio dio;
  final SecureStorage storage;

  DioClient()
    : dio = Dio(BaseOptions(baseUrl: API_BASE_URL)),
      storage = SecureStorage() {
    // 1) LogInterceptor, damit Requests/Responses in der Konsole sichtbar werden
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );

    // 2) Auth-Interceptor für Bearer-Token und automatisches Refresh
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read('accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            final rt = await storage.read('refreshToken');
            if (rt != null) {
              try {
                final resp = await dio.post(
                  '/auth/refresh',
                  data: {'refreshToken': rt},
                );
                await persistTokens(
                  resp.data['accessToken'] as String,
                  resp.data['refreshToken'] as String,
                );
                // Ursprungs-Request mit neuem Token wiederholen
                e.requestOptions.headers['Authorization'] =
                    'Bearer ${resp.data['accessToken']}';
                final clone = await dio.fetch(e.requestOptions);
                return handler.resolve(clone);
              } catch (_) {
                // wenn Refresh fehlschlägt, weiterleiten
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Speichert Access- und Refresh-Token sicher
  Future<void> persistTokens(String accessToken, String refreshToken) async {
    await storage.write('accessToken', accessToken);
    await storage.write('refreshToken', refreshToken);
  }
}
