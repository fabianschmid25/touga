import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import '../widgets/feed_card_v2.dart';
import 'feed_template_renderer.dart';

class Story43Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    final authorName =
        article.author?.name ?? article.author?.email ?? 'Unbekannter Autor';
    final categories = article.categories.map((c) => c.name).toList();

    return FeedCardV2(
      article: article,
      authorName: authorName,
      categories: categories,
    );
  }
}
