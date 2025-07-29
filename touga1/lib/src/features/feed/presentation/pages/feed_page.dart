import 'package:flutter/material.dart';
import '../../application/controllers/feed_controller.dart';
import '../../domain/entities/article.dart';
import '../widgets/feed_horizontal_view.dart';
import '../widgets/action_bar.dart';
import '../widgets/categories_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  int selectedCategoryIndex = 0;

  final List<String> categories = ['ForYou', 'Tech', 'Art', 'Science'];

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Touga Feed'), centerTitle: true),
      body: Column(
        children: [
          CategoriesBar(
            categories: categories,
            selectedIndex: selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() {
                selectedCategoryIndex = index;
              });
              // TODO: Filter nach Kategorie falls Backend vorhanden
            },
          ),
          Expanded(
            child: feedAsync.when(
              data: (articles) {
                if (articles.isEmpty) {
                  return const Center(child: Text('Keine Artikel verfügbar.'));
                }
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final Article article = articles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: FeedHorizontalView(article: article),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: ActionBar(
                              onLike: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Liked')),
                                );
                              },
                              onComment: () {},
                              onShare: () {},
                              onProfile: () {},
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Fehler: \$err')),
            ),
          ),
        ],
      ),
    );
  }
}
