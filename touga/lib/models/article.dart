class Article {
  final String id;
  final String title;
  final String teaser;
  final List<String> imageUrls;
  final String author;
  final int views;
  final int likes;

  Article({
    required this.id,
    required this.title,
    required this.teaser,
    required this.imageUrls,
    required this.author,
    required this.views,
    required this.likes,
  });
}
