import '../../domain/entities/article.dart';
import 'dart:math';

class ArticleModel {
  final String id;
  final String title;
  final List<String> imageUrls;
  final String content;
  final int likesCount;
  final int commentsCount;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
  });

  Article toEntity() => Article(
    id: id,
    title: title,
    imageUrls: imageUrls,
    content: content,
    likesCount: likesCount,
    commentsCount: commentsCount,
  );
}
