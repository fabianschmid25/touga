// lib/src/features/feed/data/repositories/feed_repository.dart

import '../datasources/feed_remote_datasource.dart';
import '../models/article_model.dart';
import '../../domain/entities/article.dart';

class FeedRepository {
  final FeedRemoteDataSource _remote;
  FeedRepository(this._remote);

  Future<List<Article>> getPage(int page) async {
    // fetchPage erwartet jetzt einen named parameter
    final models = await _remote.fetchPage(page: page);
    return models.map((m) => m.toEntity()).toList();
  }
}
