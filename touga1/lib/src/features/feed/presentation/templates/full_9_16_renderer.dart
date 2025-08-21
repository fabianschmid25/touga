import 'package:flutter/widgets.dart';

import '../../domain/entities/article.dart';
import '../widgets/feed_horizontal_view.dart';
import 'feed_template_renderer.dart';

class Full916Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    return FeedHorizontalView(
      article: article,
      onComplete: () {},
    );
  }
}
