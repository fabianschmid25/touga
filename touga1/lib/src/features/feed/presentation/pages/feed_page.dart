import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../widgets/categories_bar.dart';
import '../widgets/feed_horizontal_view.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final PageController _verticalController = PageController();
  int _selectedCategory = 0;

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  void _goToNextArticle() {
    final next = (_verticalController.page?.toInt() ?? 0) + 1;
    _verticalController.animateToPage(
      next,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            child: CategoriesBar(
              selectedIndex: _selectedCategory,
              onCategorySelected: (i) {
                setState(() => _selectedCategory = i);
                // zukünftig: Feed filtern nach Kategorie
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _verticalController,
              scrollDirection: Axis.vertical,
              itemCount: articles.length,
              onPageChanged: (i) {
                // beim Wechsel ans Ende neue laden
                if (i >= articles.length - 1) {
                  ref.read(feedControllerProvider.notifier).loadNext();
                }
              },
              itemBuilder: (context, i) {
                return FeedHorizontalView(
                  article: articles[i],
                  onComplete: _goToNextArticle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
