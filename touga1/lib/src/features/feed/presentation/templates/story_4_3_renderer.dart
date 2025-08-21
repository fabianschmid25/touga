import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import '../widgets/feed_card_v2.dart';
import 'feed_template_renderer.dart';

class Story43Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    return FeedCardV2(
      article: article,
      authorName: 'Max Meyer',
      categories: const ['Aktuelles', 'Reisen', 'Wandern'],
    );
  }
}
