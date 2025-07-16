import '../../domain/entities/article.dart';

class ArticleModel {
  final String id;
  final String title;
  final List<String> imageUrls;
  final String content;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.content,
  });

  Article toEntity() =>
      Article(id: id, title: title, imageUrls: imageUrls, content: content);
}
