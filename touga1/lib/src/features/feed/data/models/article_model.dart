// lib/src/features/feed/data/models/article_model.dart

import '../../domain/entities/article.dart';

class ArticleModel {
  final String id;
  final String title;
  final List<String> imageUrls;
  final String content;
  final String subtitle; // neu
  final int likesCount;
  final int commentsCount;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.content,
    required this.subtitle, // neu
    required this.likesCount,
    required this.commentsCount,
  });

  Article toEntity() => Article(
    id: id,
    title: title,
    imageUrls: imageUrls,
    content: content,
    subtitle: subtitle, // neu
    likesCount: likesCount,
    commentsCount: commentsCount,
  );
}
