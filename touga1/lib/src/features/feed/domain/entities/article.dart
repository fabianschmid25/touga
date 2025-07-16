// Alter Code:
// class Article { final String id, title, imageUrl, content; … }

// Neu: Liste von 3 Bild-URLs
class Article {
  final String id;
  final String title;
  final List<String> imageUrls;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.content,
  });
}
