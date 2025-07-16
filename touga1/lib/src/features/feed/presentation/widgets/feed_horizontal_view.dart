import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/article.dart';
import '../pages/article_page.dart';

/// Zeigt die 3 Bilder eines Artikels, wechselt alle 4 s automatisch
/// und ruft onComplete() auf, wenn das letzte Bild vorbei ist.
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
  late final PageController _controller;
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_current < widget.article.imageUrls.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProgressBars() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        children: List.generate(widget.article.imageUrls.length, (i) {
          if (i == _current) {
            return Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 4),
                builder: (_, value, __) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  color: Colors.white.withOpacity(0.3),
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),
            );
          } else {
            final color = i < _current ? Colors.white : Colors.white38;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                color: color,
              ),
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.article.imageUrls;
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: urls.length,
          onPageChanged: (i) {
            setState(() => _current = i);
            _startTimer();
          },
          itemBuilder: (_, i) {
            return GestureDetector(
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
            );
          },
        ),
        _buildProgressBars(),
        Positioned(
          bottom: 32,
          left: 16,
          right: 16,
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
      ],
    );
  }
}
