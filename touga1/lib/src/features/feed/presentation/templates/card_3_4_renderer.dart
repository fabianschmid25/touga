import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import '../widgets/common/headline.dart';
import '../widgets/common/meta_line_pills.dart';
import '../widgets/common/media_area.dart';
import '../widgets/common/action_bar.dart';
import 'feed_template_renderer.dart';

class Card34Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    final authorName =
        article.author?.name ?? article.author?.email ?? 'Unbekannter Autor';
    final categories = article.categories.map((c) => c.name).toList();
    final authorAvatarUrl = article.author?.avatarUrl;

    return _Card34View(
      article: article,
      authorName: authorName,
      categories: categories,
      authorAvatarUrl: authorAvatarUrl,
    );
  }
}

class _Card34View extends StatefulWidget {
  final Article article;
  final String? authorName;
  final List<String>? categories;
  final String? authorAvatarUrl;

  const _Card34View({
    super.key,
    required this.article,
    this.authorName,
    this.categories,
    this.authorAvatarUrl,
  });

  @override
  State<_Card34View> createState() => _Card34ViewState();
}

class _Card34ViewState extends State<_Card34View>
    with TickerProviderStateMixin {
  int _current = 0;
  bool _isActionBarExpanded = false;
  late AnimationController _actionBarController;
  late Animation<double> _actionBarAnimation;

  double _headlineFontSize(String title) {
    final len = title.trim().length;
    if (len <= 45) return 32;
    if (len <= 70) return 28;
    return 24;
  }

  String _formatTimestamp(DateTime updated) {
    final now = DateTime.now();
    final difference = now.difference(updated);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  void initState() {
    super.initState();
    _actionBarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _actionBarAnimation = CurvedAnimation(
      parent: _actionBarController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _actionBarController.dispose();
    super.dispose();
  }

  void _toggleActionBar() {
    setState(() {
      _isActionBarExpanded = !_isActionBarExpanded;
    });

    if (_isActionBarExpanded) {
      _actionBarController.forward();
    } else {
      _actionBarController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Höhe wird durch Expanded gesteuert; frühere fixe Höhe entfernt

    final displayAuthor = widget.authorName ?? 'Max Meyer';
    final displayCats =
        widget.categories ?? const ['Aktuelles', 'Reisen', 'Wandern'];

    final headlineText = widget.article.title.toUpperCase();
    final int titleLen = headlineText.length;
    final int imageFlex = titleLen > 80
        ? 50
        : titleLen > 55
            ? 54
            : 56;
    final int bottomFlex = titleLen > 80
        ? 6
        : titleLen > 55
            ? 8
            : 12;
    final int headlineMaxLines = titleLen > 70 ? 4 : 3;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: imageFlex,
                    child: SizedBox.expand(
                      child: MediaArea(
                        images: widget.article.imageUrls,
                        aspectRatio: null,
                        borderRadius: 0,
                        showIndicators: true,
                        currentIndex: _current,
                        onPageChanged: (i) => setState(() => _current = i),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ArticlePage(article: widget.article),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Meta-Zeile mit Autor & Timestamp
                  Row(
                    children: [
                      // Profilbild (Viereck)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.grey[200]!, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://i.pravatar.cc/150?u=${widget.article.id}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Autor-Name und Timestamp
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayAuthor,
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTimestamp(widget.article.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ArticlePage(article: widget.article),
                        ),
                      );
                    },
                    child: Headline(
                      text: headlineText,
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontSize: _headlineFontSize(headlineText),
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: headlineMaxLines,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Footer-Aktion
                  ActionBar(
                    isExpanded: _isActionBarExpanded,
                    animation: _actionBarAnimation,
                    onTap: _toggleActionBar,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
