import '../../domain/entities/article.dart';

ArticleTemplate? _parseTemplateModel(String? value) {
  switch (value) {
    case 'FULL_9_16':
      return ArticleTemplate.full916;
    case 'CARD_3_4':
      return ArticleTemplate.card34;
    case 'STORY_4_3':
      return ArticleTemplate.story43;
    case 'STORY_4_3_V1':
      return ArticleTemplate.story43V1;
    case 'STORY_4_3_V2':
      return ArticleTemplate.story43V2;
    default:
      return null;
  }
}

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String subtitle;
  final List<String> imageUrls;
  final String authorId;
  final DateTime createdAt;
  final ArticleTemplate? template;
  final ArticleAuthor? author;
  final List<ArticleCategory> categories;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.subtitle,
    required this.imageUrls,
    required this.authorId,
    required this.createdAt,
    this.template,
    this.author,
    this.categories = const [],
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
      template: _parseTemplateModel(json['template'] as String?),
      author: json['author'] != null
          ? ArticleAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((cat) =>
                  ArticleCategory.fromJson(cat as Map<String, dynamic>))
              .toList() ??
          [],
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
      template: template,
      author: author,
      categories: categories,
    );
  }
}
