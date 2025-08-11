import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import 'action_bar.dart';

class FeedHorizontalView extends StatefulWidget {
  final Article article;
  final VoidCallback onComplete;

  const FeedHorizontalView({
    Key? key,
    required this.article,
    required this.onComplete,
  }) : super(key: key);

  @override
  _FeedHorizontalViewState createState() => _FeedHorizontalViewState();
}

class _FeedHorizontalViewState extends State<FeedHorizontalView> {
  late final PageController _pageController;
  int _current = 0;

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

  void _onPageChanged(int index) {
    setState(() => _current = index);
  }

  @override
  Widget build(BuildContext context) {
    // ← Hier der bestehende Debug-Print bleibt erhalten:
    print('▶️ [FeedHorizontalView] imageUrls: ${widget.article.imageUrls}');

    final urls = widget.article.imageUrls;

    return Stack(
      children: [
        // PageView mit Swipe-Logik bleibt unverändert
        PageView.builder(
          controller: _pageController,
          itemCount: urls.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (_, i) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArticlePage(article: widget.article),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: urls[i],
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),

        // Titel, Subtitle und Indikatoren
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_current == 0) ...[
                Text(
                  widget.article.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArticlePage(article: widget.article),
                  ),
                ),
                child: Text(
                  widget.article.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Statische Indikator-Balken ohne Autoplay
              Row(
                children: List.generate(urls.length, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      color: i <= _current ? Colors.white : Colors.white38,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // ActionBar bleibt unverändert
        Positioned(
          right: 16,
          bottom: 120,
          child: ActionBar(
            article: widget.article,
            onLike: () {
              // TODO: Like-Logik
            },
            onComment: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArticlePage(article: widget.article),
              ),
            ),
            onShare: () {
              // TODO: Share-Dialog
            },
          ),
        ),
      ],
    );
  }
}
