import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import 'card_3_4_view.dart';
import 'feed_template_renderer.dart';

class Card34Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    return Card34View(
      article: article,
      authorName: 'Max Meyer',
      categories: const ['Aktuelles', 'Reisen', 'Wandern'],
    );
  }
}
