import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/article.dart';
import '../templates/feed_template_renderer.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Text(
            'Fehler beim Laden: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(
              child: Text(
                'Keine Artikel vorhanden',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final Article a = articles[index];
              return FeedTemplateRegistry.of(a).build(context, a);
            },
          );
        },
      ),
    );
  }
}
