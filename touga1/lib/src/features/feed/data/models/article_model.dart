// lib/src/features/feed/data/models/article_model.dart

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
      imageUrls: List<String>.from(json['imageUrls'] as List<dynamic>),
      authorId: json['authorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
