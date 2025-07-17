import '../models/article_model.dart';
import 'dart:math';

class FeedRemoteDataSource {
  final _rnd = Random();

  /// Simuliere 5 Artikel pro Seite, jeder mit 3 Bildern und zufälligen Countern
  Future<List<ArticleModel>> fetchPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(5, (i) {
      final idx = page * 5 + i + 1;
      // drei unterschiedliche Picsum-URLs
      final imgs = List.generate(
        3,
        (j) => 'https://picsum.photos/900/1600?random=${idx * 10 + j}',
      );
      // mock counts
      final likes = _rnd.nextInt(500); // 0–499
      final comments = _rnd.nextInt(100); // 0–99

      return ArticleModel(
        id: 'article_$idx',
        title: 'Artikel $idx',
        imageUrls: imgs,
        content: 'Inhalt von Artikel $idx…\n\nLorem ipsum…',
        likesCount: likes,
        commentsCount: comments,
      );
    });
  }
}
