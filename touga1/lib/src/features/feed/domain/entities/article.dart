enum ArticleTemplate { full916, card34, story43, story43V1, story43V2 }

ArticleTemplate? _parseTemplate(String? value) {
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

class ArticleAuthor {
  final String id;
  final String? name;
  final String email;
  final String? avatarUrl;

  ArticleAuthor({
    required this.id,
    this.name,
    required this.email,
    this.avatarUrl,
  });

  factory ArticleAuthor.fromJson(Map<String, dynamic> json) {
    return ArticleAuthor(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class ArticleCategory {
  final String id;
  final String name;

  ArticleCategory({
    required this.id,
    required this.name,
  });

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class Article {
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

  Article({
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
      template: _parseTemplate(json['template'] as String?),
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
}
