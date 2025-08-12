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
    // Debug bleibt bestehen
    // ignore: avoid_print
    print('▶️ [FeedHorizontalView] imageUrls: ${widget.article.imageUrls}');

    final urls = widget.article.imageUrls;

    return Stack(
      children: [
        // 1) Der Content (Bilder im PageView)
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

        // 2) TikTok-typische Edge-Scrims (oben & unten) für bessere Lesbarkeit
        //    Liegen über dem Video, aber unter deinen Texten/Buttons.
        Positioned.fill(
          child: IgnorePointer(
            child: Column(
              children: [
                // TOP-SCRIM (für Status-Icons / Kategorien)
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.60),
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                const Spacer(),
                // BOTTOM-SCRIM (für Titel / Untertitel / ActionBar)
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.70),
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3) Titel, Subtitle und Indikatoren
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
                    shadows: [
                      Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(0, 1)),
                    ],
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
                child: const _ArticleTitle(),
              ),
              const SizedBox(height: 8),

              // Statische Indikator-Balken (kein Autoplay)
              Row(
                children: List.generate(urls.length, (i) {
                  final active = i <= _current;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: active ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // 4) ActionBar
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

/// Separater Titel-Widget mit starkem Shadow, damit es auf hellem Hintergrund gut lesbar ist.
class _ArticleTitle extends StatelessWidget {
  const _ArticleTitle();

  @override
  Widget build(BuildContext context) {
    final article =
        (context.findAncestorStateOfType<_FeedHorizontalViewState>())!
            .widget
            .article;
    return Text(
      article.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(0, 2)),
        ],
      ),
    );
  }
}
