import '../models/article_model.dart';

class FeedRemoteDataSource {
  /// Simuliere 5 Artikel pro Page, jeder mit 3 Bildern
  Future<List<ArticleModel>> fetchPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(5, (i) {
      final idx = page * 5 + i + 1;
      // Erzeuge drei unterschiedliche Picsum-URLs pro Artikel
      final imgs = List.generate(
        3,
        (j) => 'https://picsum.photos/900/1600?random=${idx * 10 + j}',
      );
      return ArticleModel(
        id: 'article_$idx',
        title: 'Artikel $idx',
        imageUrls: imgs,
        content: 'Inhalt von Artikel $idx…\n\nLorem ipsum…',
      );
    });
  }
}
