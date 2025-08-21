import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import 'card_3_4_renderer.dart';
import 'full_9_16_renderer.dart';
import 'story_4_3_renderer.dart';

abstract class FeedTemplateRenderer {
  Widget build(BuildContext context, Article article);
}

class FeedTemplateRegistry {
  static final Map<ArticleTemplate, FeedTemplateRenderer> _map = {
    ArticleTemplate.full916: Full916Renderer(),
    ArticleTemplate.card34: Card34Renderer(),
    ArticleTemplate.story43: Story43Renderer(),
  };

  static FeedTemplateRenderer of(Article article) {
    final tpl = article.template;
    if (tpl == null) return Card34Renderer();
    return _map[tpl] ?? Card34Renderer();
  }
}
