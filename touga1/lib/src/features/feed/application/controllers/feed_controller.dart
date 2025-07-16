import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_feed_page.dart';

class FeedController extends StateNotifier<List<Article>> {
  final GetFeedPage _getFeedPage;
  int _page = 0;
  bool _loading = false;

  FeedController(this._getFeedPage) : super([]) {
    loadNext();
  }

  Future<void> loadNext() async {
    if (_loading) return;
    _loading = true;
    final newArticles = await _getFeedPage(_page);
    state = [...state, ...newArticles];
    _page++;
    _loading = false;
  }
}
