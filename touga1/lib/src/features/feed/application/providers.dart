import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/feed_remote_datasource.dart';
import '../data/repositories/feed_repository.dart';
import '../domain/usecases/get_feed_page.dart';
import 'controllers/feed_controller.dart';
import '../domain/entities/article.dart';

final feedRemoteDsProvider = Provider((_) => FeedRemoteDataSource());
final feedRepoProvider = Provider(
  (ref) => FeedRepository(ref.read(feedRemoteDsProvider)),
);
final getFeedPageProvider = Provider(
  (ref) => GetFeedPage(ref.read(feedRepoProvider)),
);
final feedControllerProvider =
    StateNotifierProvider<FeedController, List<Article>>(
      (ref) => FeedController(ref.read(getFeedPageProvider)),
    );
