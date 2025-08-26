import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import '../widgets/common/headline.dart';
import '../widgets/common/meta_line_pills.dart';
import '../widgets/common/action_bar.dart';
import 'feed_template_renderer.dart';

class Story43Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    final authorName =
        article.author?.name ?? article.author?.email ?? 'Unbekannter Autor';
    final categories = article.categories.map((c) => c.name).toList();
    final authorAvatarUrl = article.author?.avatarUrl;

    return _Story43View(
      article: article,
      authorName: authorName,
      categories: categories,
      authorAvatarUrl: authorAvatarUrl,
    );
  }
}

/// Story 4:3 Design - Card-Layout mit sauberer Struktur:
/// - Weißer Hintergrund mit einheitlichem Padding
/// - Bild oben (40% Höhe, volle Breite)
/// - Meta-Zeile mit Author und Kategorien
/// - Große Headline
/// - Content-Teaser
/// - Footer-Aktion Button
class _Story43View extends StatefulWidget {
  final Article article;
  final String? authorName;
  final List<String>? categories;
  final String? authorAvatarUrl;

  const _Story43View({
    Key? key,
    required this.article,
    this.authorName,
    this.categories,
    this.authorAvatarUrl,
  }) : super(key: key);

  @override
  State<_Story43View> createState() => _Story43ViewState();
}

class _Story43ViewState extends State<_Story43View>
    with TickerProviderStateMixin {
  int _current = 0;
  bool _isActionBarExpanded = false;
  late AnimationController _actionBarController;
  late Animation<double> _actionBarAnimation;

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

  String _extractTeaser(String content, {int maxChars = 200}) {
    // HTML-Tags entfernen
    final noTags = content.replaceAll(RegExp(r'<[^>]*>'), ' ');
    final text = noTags.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (text.length <= maxChars) return text;

    // Finde den letzten vollständigen Satz
    final truncated = text.substring(0, maxChars);
    final lastPeriod = truncated.lastIndexOf('.');
    final lastExclamation = truncated.lastIndexOf('!');
    final lastQuestion = truncated.lastIndexOf('?');

    final lastSentenceEnd = [lastPeriod, lastExclamation, lastQuestion]
        .where((i) => i > 0)
        .reduce((a, b) => a > b ? a : b);

    if (lastSentenceEnd > maxChars * 0.7) {
      return '${truncated.substring(0, lastSentenceEnd + 1)}…';
    }

    return '$truncated…';
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
    final padding = const EdgeInsets.all(16.0);
    final imageHeight = size.height * 0.35; // Reduziert von 40% auf 35%

    final displayAuthor = widget.authorName ?? 'Max Meyer';
    final displayCats =
        widget.categories ?? const ['Aktuelles', 'Reisen', 'Wandern'];
    final teaser = _extractTeaser(widget.article.content);

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Bild (Header) =====
              if (widget.article.imageUrls.isNotEmpty) ...[
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: _ImageCarousel(
                    images: widget.article.imageUrls,
                    currentIndex: _current,
                    onPageChanged: (i) => setState(() => _current = i),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ArticlePage(article: widget.article),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ===== Meta-Zeile mit Autor & Timestamp =====
              Row(
                children: [
                  // Profilbild (Viereck)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
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
              const SizedBox(height: 12),

              // ===== Headline =====
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArticlePage(article: widget.article),
                    ),
                  );
                },
                child: Text(
                  widget.article.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 12),

              // ===== Content-Teaser =====
              Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.12, // Reduziert von 15% auf 12%
                ),
                child: Text(
                  teaser,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF475569),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3, // Reduziert von 4 auf 3 Zeilen
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ===== Flexibler Abstand =====
              Expanded(
                child: const SizedBox.shrink(),
              ),

              // ===== Footer-Aktion =====
              const SizedBox(height: 16), // Reduziert von 20 auf 16
              ActionBar(
                isExpanded: _isActionBarExpanded,
                animation: _actionBarAnimation,
                onTap: _toggleActionBar,
              ),

              // ===== Whitespace am Ende =====
              const SizedBox(height: 12), // Reduziert von 16 auf 12
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onTap;

  const _ImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: images.first,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.error)),
          ),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: onTap,
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.error)),
                ),
              ),
            );
          },
        ),
        // Bild-Indikatoren
        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == currentIndex;
                return Container(
                  width: isActive ? 24 : 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
