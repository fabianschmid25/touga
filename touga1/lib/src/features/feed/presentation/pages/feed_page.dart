import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../widgets/categories_bar.dart';
import '../widgets/feed_horizontal_view.dart';
import '../../domain/entities/article.dart';

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
    final feedState = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            child: CategoriesBar(
              selectedIndex: _selectedCategory,
              onCategorySelected: (i) {
                setState(() => _selectedCategory = i);
                // TODO: In Zukunft Feed nach Kategorie filtern
              },
            ),
          ),
          Expanded(
            child: feedState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Fehler: \$e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              data: (List<Article> articles) {
                if (articles.isEmpty) {
                  return const Center(
                    child: Text(
                      'Keine Artikel vorhanden',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return PageView.builder(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  itemCount: articles.length,
                  onPageChanged: (i) {
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
