import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import 'common/headline.dart';
import 'common/meta_line.dart';

/// Eine ganze "Seite" im Magazin-Look (wie das Beispielbild):
/// - Vollseite mit weißem Hintergrund, aber Inhalt als Card-Layout
/// - Oben großes Bild (rounded, BoxFit.cover), optional bis zu 3 Bilder (horizontal swipen)
/// - Bild-Indikatoren IM Bild, dezent
/// - Darunter Meta-Zeile: "AUTOR / KAT1 / KAT2 / KAT3"
/// - Sehr große Headline + optional kurzer Teaser
/// - Kein eigener Scroll: Die Seite selbst wird im vertikalen PageView geswiped
class FeedCardV2 extends StatefulWidget {
  final Article article;

  // Dummy-Daten bis Backend liefert
  final String? authorName;
  final List<String>? categories;

  const FeedCardV2({
    Key? key,
    required this.article,
    this.authorName,
    this.categories,
  }) : super(key: key);

  @override
  State<FeedCardV2> createState() => _FeedCardV2State();
}

class _FeedCardV2State extends State<FeedCardV2> {
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
                        builder: (_) => ArticlePage(article: widget.article)),
                  );
                },
                child: Headline(text: title),
              ),

              const SizedBox(height: 10),

              // ===== Kurzer Teaser (wenn Platz) ================================
              if (excerptLines > 0)
                Text(
                  _excerptFromHtml(widget.article.content),
                  maxLines: excerptLines,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 16,
                    height: 1.52,
                  ),
                ),

              // kein eigener Scroll, damit das vertikale PageView sauber snappt
              // unten bewusst etwas Luft, damit die Seite atmen kann
              const Spacer(),
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
    final borderRadius = BorderRadius.circular(12);

    Widget imageContent = images.isNotEmpty
        ? PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => CachedNetworkImage(
              imageUrl: images[i],
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image_outlined,
                    size: 36, color: Colors.black38),
              ),
            ),
          )
        : Container(color: const Color(0xFFE5E7EB));

    // Indikatoren unten im Bild
    Widget indicators = Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(images.length, (i) {
          final active = i == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            width: active ? 28 : 14,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(active ? 1.0 : 0.7),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );

    // Tap Overlay
    Widget tapOverlay = Positioned.fill(
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
                  if (images.length > 1) indicators,
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
            if (images.length > 1) indicators,
            tapOverlay,
          ],
        ),
      ),
    );
  }
}
