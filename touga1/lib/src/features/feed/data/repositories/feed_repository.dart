import '../datasources/feed_remote_datasource.dart';
import '../../domain/entities/article.dart';

class FeedRepository {
  final FeedRemoteDataSource _remote;
  FeedRepository(this._remote);

  Future<List<Article>> getPage(int page) async {
    final models = await _remote.fetchPage(page);
    return models.map((m) => m.toEntity()).toList();
  }
}
