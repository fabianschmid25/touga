// lib/src/features/feed/presentation/widgets/feed_horizontal_view.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import 'action_bar.dart';

/// Zeigt die 3 Bilder eines Artikels,
/// wechselt alle 4 s automatisch und springt am Ende per onComplete() vertikal weiter.
/// - Pointer‑Down → Pause
/// - Pointer‑Up → Resume
/// - Long‑Press ebenfalls Pause/Resume
/// Zusätzlich erscheinen rechts Profil‑, Like‑, Kommentar‑ und Share‑Icons.
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

class _FeedHorizontalViewState extends State<FeedHorizontalView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (_current < widget.article.imageUrls.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                widget.onComplete();
              }
            }
          });
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _current = index);
    _animController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.article.imageUrls;

    return Listener(
      onPointerDown: (_) => _animController.stop(), // sofort pause
      onPointerUp: (_) => _animController.forward(), // sofort resume
      child: Stack(
        children: [
          // 1) Bild-Carousel
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
              onLongPressStart: (_) => _animController.stop(),
              onLongPressEnd: (_) => _animController.forward(),
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

          // 2) Titel + Progress Bars unten
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Klickbarer Titel
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress Bars
                Row(
                  children: List.generate(urls.length, (i) {
                    if (i < _current) {
                      // abgeschlossene Slides
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          color: Colors.white,
                        ),
                      );
                    } else if (i == _current) {
                      // aktueller Slide mit Animation
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          color: Colors.white38,
                          child: AnimatedBuilder(
                            animation: _animController,
                            builder: (_, __) => FractionallySizedBox(
                              widthFactor: _animController.value,
                              alignment: Alignment.centerLeft,
                              child: Container(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // kommende Slides
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          color: Colors.white38,
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),

          // 3) ActionBar rechts
          Positioned(
            right: 16,
            bottom: 80,
            child: ActionBar(
              article: widget.article,
              onLike: () {
                // TODO: Like‑Logik
              },
              onComment: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArticlePage(article: widget.article),
                  ),
                );
              },
              onShare: () {
                // TODO: Share‑Dialog öffnen
              },
            ),
          ),
        ],
      ),
    );
  }
}
