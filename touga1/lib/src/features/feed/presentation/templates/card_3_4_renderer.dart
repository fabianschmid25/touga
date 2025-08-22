import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import 'card_3_4_view.dart';
import 'feed_template_renderer.dart';

class Card34Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    final authorName =
        article.author?.name ?? article.author?.email ?? 'Unbekannter Autor';
    final categories = article.categories.map((c) => c.name).toList();

    return Card34View(
      article: article,
      authorName: authorName,
      categories: categories,
    );
  }
}
