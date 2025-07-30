class Article {
  final String id;
  final String title;
  final String content;
  final String subtitle;
  final List<String> imageUrls;
  final String authorId;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.subtitle,
    required this.imageUrls,
    required this.authorId,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      subtitle: json['subtitle'] ?? '',
      imageUrls: (json['images'] as List<dynamic>)
          .map((image) => image['url'] as String)
          .toList(),
      authorId: json['authorId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
