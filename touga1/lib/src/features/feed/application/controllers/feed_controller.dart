// lib/src/features/feed/application/controllers/feed_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_feed_page.dart';

/// StateNotifier, das den Feed lädt und verwaltet.
class FeedController extends StateNotifier<AsyncValue<List<Article>>> {
  final GetFeedPage _getFeedPage;

  FeedController(this._getFeedPage) : super(const AsyncValue.loading()) {
    loadNext();
  }

  /// Lädt die nächste Seite (hier immer mit page = 0).
  Future<void> loadNext() async {
    debugPrint('➡️ [FeedController] Loading page 0…');
    try {
      final articles = await _getFeedPage(0);
      debugPrint('✅ [FeedController] Loaded ${articles.length} articles');
      state = AsyncValue.data(articles);
    } catch (e, st) {
      debugPrint('❌ [FeedController] Error: $e');
      debugPrint('🐞 [FeedController] StackTrace:\n$st');
      state = AsyncValue.error(e, st);
    }
  }
}
