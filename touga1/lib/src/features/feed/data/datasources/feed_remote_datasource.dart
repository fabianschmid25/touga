import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class FeedRemoteDataSource {
  // Ersetze durch deine lokale PC‑IP oder ngrok‑URL
  static const _baseUrl = 'http://192.168.2.118:3000';

  /// Lädt die Artikelliste vom Backend und loggt jeden Schritt.
  Future<List<ArticleModel>> fetchPage({int page = 0}) async {
    final uri = Uri.parse('$_baseUrl/articles');
    debugPrint('🔎 [FeedRemote] GET $uri (page=$page)');
    try {
      // 15‑Sekunden Timeout, um lange Hänger abzufangen
      final resp = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw Exception('⏱️ Timeout nach 15s beim GET $uri'),
          );

      debugPrint('📥 [FeedRemote] Status: ${resp.statusCode}');
      debugPrint('📄 [FeedRemote] Body: ${resp.body}');

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
      }

      final jsonData = json.decode(resp.body) as List<dynamic>;
      return jsonData
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      debugPrint('❌ [FeedRemote] Unerwarteter Fehler: $e');
      debugPrint('🐛 [FeedRemote] StackTrace:\n$st');
      rethrow;
    }
  }
}
