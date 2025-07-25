import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../widgets/feed_horizontal_view.dart';
import '../../domain/entities/article.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: feedState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Fehler: $e',
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

          // Vertikales Pagenavigation: jeder Artikel eine Seite
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return FeedHorizontalView(
                article: articles[index],
                onComplete: () {
                  // wenn Bild‑Slideshow fertig, automatisch zum nächsten Artikel swipen
                  if (index < articles.length - 1) {
                    PageController controller = PageController(
                      initialPage: index + 1,
                    );
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
