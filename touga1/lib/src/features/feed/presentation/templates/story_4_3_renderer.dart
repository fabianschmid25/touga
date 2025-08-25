import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import '../widgets/common/headline.dart';
import '../widgets/common/meta_line.dart';
import 'feed_template_renderer.dart';

class Story43Renderer implements FeedTemplateRenderer {
  @override
  Widget build(BuildContext context, Article article) {
    final authorName =
        article.author?.name ?? article.author?.email ?? 'Unbekannter Autor';
    final categories = article.categories.map((c) => c.name).toList();

    return _Story43View(
      article: article,
      authorName: authorName,
      categories: categories,
    );
  }
}

/// Eine ganze "Seite" im Magazin-Look (wie das Beispielbild):
/// - Vollseite mit weißem Hintergrund, aber Inhalt als Card-Layout
/// - Oben großes Bild (rounded, BoxFit.cover), optional bis zu 3 Bilder (horizontal swipen)
/// - Bild-Indikatoren IM Bild, dezent
/// - Darunter Meta-Zeile: "AUTOR / KAT1 / KAT2 / KAT3"
/// - Sehr große Headline + optional kurzer Teaser
/// - Kein eigener Scroll: Die Seite selbst wird im vertikalen PageView geswiped
class _Story43View extends StatefulWidget {
  final Article article;

  // Dummy-Daten bis Backend liefert
  final String? authorName;
  final List<String>? categories;

  const _Story43View({
    Key? key,
    required this.article,
    this.authorName,
    this.categories,
  }) : super(key: key);

  @override
  State<_Story43View> createState() => _Story43ViewState();
}

class _Story43ViewState extends State<_Story43View> {
  int _current = 0;

  List<String> get _images {
    final urls = widget.article.imageUrls;
    if (urls.isEmpty) return [];
    return urls.take(3).toList();
  }

  String _excerptFromHtml(String html, {int maxChars = 220}) {
    final noTags = html.replaceAll(RegExp(r'<[^>]*>'), ' ');
    final text = noTags.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length <= maxChars
        ? text
        : '${text.substring(0, maxChars).trim()}…';
  }

  int _titleBucket(String title) {
    final len = title.trim().length;
    if (len <= 45) return 3; // kurzer Titel -> mehr Excerpt
    if (len <= 70) return 2; // mittel
    return 1; // lang -> wenig Excerpt
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Seite = Bildschirm

    final title = widget.article.title;
    final excerptLines = _titleBucket(title);

    final template = widget.article.template; // steuert Layout-Variante

    // Bildhöhe so wählen, dass es "wie im Beispiel" wirkt:
    // ~ obere 60% Bild, unten Textblock
    final imageHeight = (size.height * 0.58).clamp(360.0, 640.0);

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Großes Bild mit runden Ecken, Cover, Indikatoren im Bild ===
              _TemplateImageArea(
                template: template,
                imageHeight: imageHeight,
                images: _images,
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

              const SizedBox(height: 20),

              // ===== Meta-Zeile =================================================
              MetaLine(
                author: widget.authorName ?? 'Max Meyer',
                categories: widget.categories ??
                    const ['Aktuelles', 'Reisen', 'Wandern'],
              ),

              const SizedBox(height: 12),

              // ===== Headline (sehr groß, klickbar) =============================
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArticlePage(article: widget.article),
                    ),
                  );
                },
                child: Headline(
                  text: title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 3,
                ),
              ),

              // ===== Excerpt (optional, abhängig von Titel-Länge) ===============
              if (excerptLines > 1) ...[
                const SizedBox(height: 12),
                Text(
                  _excerptFromHtml(widget.article.content),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF475569),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: excerptLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateImageArea extends StatelessWidget {
  final ArticleTemplate? template;
  final double imageHeight;
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onTap;

  const _TemplateImageArea({
    required this.template,
    required this.imageHeight,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return SizedBox(
        height: imageHeight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.image, size: 48, color: Colors.grey),
          ),
        ),
      );
    }

    final borderRadius = BorderRadius.circular(12);
    final imageContent = images.length == 1
        ? _SingleImage(images.first)
        : _MultiImageCarousel(
            images: images,
            currentIndex: currentIndex,
            onPageChanged: onPageChanged,
          );

    final indicators = images.length > 1
        ? Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == currentIndex;
                return Container(
                  width: isActive ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          )
        : const SizedBox.shrink();

    final tapOverlay = Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap),
      ),
    );

    // CARD/STORY: fester Bereich mit Seitenverhältnissen 3:4 oder 4:3
    if (template == ArticleTemplate.card34 ||
        template == ArticleTemplate.story43 ||
        template == null) {
      final aspectRatio = template == ArticleTemplate.story43 ? 4 / 3 : 3 / 4;
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: imageHeight,
            maxWidth: 1000,
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageContent,
                  indicators,
                  tapOverlay,
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Fallback (sollte hier nicht landen, FULL_9_16 nutzt eigenes Widget in FeedPage)
    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageContent,
            indicators,
            tapOverlay,
          ],
        ),
      ),
    );
  }
}

class _SingleImage extends StatelessWidget {
  final String imageUrl;

  const _SingleImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.error)),
      ),
    );
  }
}

class _MultiImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _MultiImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return _SingleImage(images[index]);
      },
    );
  }
}
