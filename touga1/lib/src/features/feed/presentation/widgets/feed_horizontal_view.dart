import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../pages/article_page.dart';

class FeedHorizontalView extends StatefulWidget {
  final Article article;

  const FeedHorizontalView({super.key, required this.article});

  @override
  State<FeedHorizontalView> createState() => _FeedHorizontalViewState();
}

class _FeedHorizontalViewState extends State<FeedHorizontalView> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isHolding) return;
      if (_currentPage < (widget.article.imageUrls.length - 1)) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onTapZone(TapUpDetails details, BoxConstraints constraints) {
    final dx = details.localPosition.dx;
    final width = constraints.maxWidth;
    if (dx < width / 2 && _currentPage > 0) {
      _currentPage--;
    } else if (dx >= width / 2 &&
        _currentPage < widget.article.imageUrls.length - 1) {
      _currentPage++;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => setState(() => _isHolding = true),
          onLongPressEnd: (_) => setState(() => _isHolding = false),
          onTapUp: (details) => _onTapZone(
            details,
            context.size != null
                ? BoxConstraints.tight(context.size!)
                : const BoxConstraints(),
          ),
          child: SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.article.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.article.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
              onPageChanged: (index) => _currentPage = index,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticlePage(article: widget.article),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(
                  widget.article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.article.subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
