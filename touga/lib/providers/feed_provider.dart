import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../core/dummy_data.dart';

final feedProvider = Provider<List<Article>>((ref) {
  return mockArticles;
});
