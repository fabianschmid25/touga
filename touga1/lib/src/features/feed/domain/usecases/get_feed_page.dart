import '../entities/article.dart';
import '../../data/repositories/feed_repository.dart';

class GetFeedPage {
  final FeedRepository _repo;
  GetFeedPage(this._repo);

  Future<List<Article>> call(int page) => _repo.getPage(page);
}
