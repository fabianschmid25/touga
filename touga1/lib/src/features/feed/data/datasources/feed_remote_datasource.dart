// lib/src/features/feed/data/datasources/feed_remote_datasource.dart

import 'dart:math';
import '../models/article_model.dart';

class FeedRemoteDataSource {
  final _rnd = Random();

  /// Simuliere 5 Artikel pro Seite,
  /// jeder mit 3 Bildern, zufälligen Countern und einem Subtitle.
  Future<List<ArticleModel>> fetchPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.generate(5, (i) {
      final idx = page * 5 + i + 1;

      // Drei zufällige Bilder pro Artikel
      final imgs = List.generate(
        3,
        (j) => 'https://picsum.photos/900/1600?random=${idx * 10 + j}',
      );

      // Mock-Zähler
      final likes = _rnd.nextInt(500); // 0–499
      final comments = _rnd.nextInt(100); // 0–99

      // Begleitspruch
      final subtitle = 'Kurzer Begleittext zu Artikel $idx';

      return ArticleModel(
        id: 'article_$idx',
        title: 'Artikel $idx',
        imageUrls: imgs,
        content: 'Inhalt von Artikel $idx…\n\nLorem ipsum dolor sit amet.',
        subtitle: subtitle, // neu
        likesCount: likes,
        commentsCount: comments,
      );
    });
  }
}
