import '../../domain/entities/article.dart';

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String subtitle;
  final List<String> imageUrls;
  final String authorId;
  final DateTime createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.subtitle,
    required this.imageUrls,
    required this.authorId,
    required this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      authorId: json['authorId'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Article toEntity() {
    return Article(
      id: id,
      title: title,
      content: content,
      subtitle: subtitle,
      imageUrls: imageUrls,
      authorId: authorId,
      createdAt: createdAt,
    );
  }
}
