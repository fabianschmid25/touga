// lib/src/features/feed/application/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/feed_remote_datasource.dart';
import '../data/repositories/feed_repository.dart';
import '../domain/usecases/get_feed_page.dart';
import 'controllers/feed_controller.dart';
import '../domain/entities/article.dart';

/// 1) Remote‑Datasource
final feedRemoteDataSourceProvider = Provider<FeedRemoteDataSource>(
  (ref) => FeedRemoteDataSource(),
);

/// 2) Repository
final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => FeedRepository(ref.read(feedRemoteDataSourceProvider)),
);

/// 3) UseCase
final getFeedPageProvider = Provider<GetFeedPage>(
  (ref) => GetFeedPage(ref.read(feedRepositoryProvider)),
);

/// 4) Controller (StateNotifier) – liefert AsyncValue<List<Article>>
final feedControllerProvider =
    StateNotifierProvider<FeedController, AsyncValue<List<Article>>>(
      (ref) => FeedController(ref.read(getFeedPageProvider)),
    );
