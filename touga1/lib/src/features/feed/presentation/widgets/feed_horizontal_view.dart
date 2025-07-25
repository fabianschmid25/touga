// lib/src/features/feed/presentation/widgets/feed_horizontal_view.dart

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';

/// Zeigt pro Artikel die drei Bilder in 9:16,
/// wechselt automatisch alle 4 Sekunden und pausiert bei Touch.
class FeedHorizontalView extends StatefulWidget {
  final Article article;

  /// Wird aufgerufen, wenn dieser Artikel komplett angezeigt wurde.
  /// Kann z. B. genutzt werden, um zum nächsten Artikel zu wechseln.
  final VoidCallback? onComplete;

  const FeedHorizontalView({Key? key, required this.article, this.onComplete})
    : super(key: key);

  @override
  State<FeedHorizontalView> createState() => _FeedHorizontalViewState();
}

class _FeedHorizontalViewState extends State<FeedHorizontalView> {
  static const _displayDuration = Duration(seconds: 4);
  late final PageController _pageController;
  Timer? _timer;
  bool _isTouching = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _timer?.cancel();
    _timer = Timer.periodic(_displayDuration, (_) {
      if (_isTouching) return;
      final next = _pageController.page!.toInt() + 1;
      if (next < widget.article.imageUrls.length) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        widget.onComplete?.call();
      }
    });
  }

  void _pauseAutoSwitch() {
    _isTouching = true;
  }

  void _resumeAutoSwitch() {
    _isTouching = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aktuelle Page (als double), oder 0.0 wenn noch keine Clients
    final currentPage = _pageController.hasClients
        ? (_pageController.page ?? _pageController.initialPage.toDouble())
        : 0.0;

    return GestureDetector(
      onLongPressStart: (_) => _pauseAutoSwitch(),
      onLongPressEnd: (_) => _resumeAutoSwitch(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Bilder horizontal swipen
          PageView.builder(
            controller: _pageController,
            itemCount: widget.article.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.article.imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (c, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
            onPageChanged: (_) => _startAutoSwitch(),
          ),

          // Progress‑Balken unten unter dem Titel
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              children: List.generate(widget.article.imageUrls.length, (i) {
                // Berechne den Fortschritt für Balken i
                final value = currentPage >= (i + 1)
                    ? 1.0
                    : (currentPage - i).clamp(0.0, 1.0) as double;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Titel + Subtitle
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle nur beim ersten Bild
                if (currentPage < 1 && widget.article.subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      widget.article.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),

                Text(
                  widget.article.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
