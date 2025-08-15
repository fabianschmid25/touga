import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';

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
    final author = (widget.authorName ?? 'Max Meyer').toUpperCase();
    final cats = (widget.categories ?? const ['Aktuelles', 'Reisen', 'Wandern'])
        .take(3)
        .map((e) => e.toUpperCase())
        .toList();
    final meta = cats.isNotEmpty ? '$author / ${cats.join(' / ')}' : author;

    final title = widget.article.title;
    final excerptLines = _titleBucket(title);

    // Bildhöhe so wählen, dass es "wie im Beispiel" wirkt:
    // ~ obere 60% Bild, unten Textblock
    final imageHeight = (size.height * 0.58).clamp(360.0, 640.0);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Großes Bild mit runden Ecken, Cover, Indikatoren im Bild ===
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_images.isNotEmpty)
                        PageView.builder(
                          itemCount: _images.length,
                          onPageChanged: (i) => setState(() => _current = i),
                          itemBuilder: (_, i) => CachedNetworkImage(
                            imageUrl: _images[i],
                            fit: BoxFit
                                .cover, // wie im Beispiel: füllt den Bildrahmen
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image_outlined,
                                  size: 36, color: Colors.black38),
                            ),
                          ),
                        )
                      else
                        Container(color: const Color(0xFFE5E7EB)),

                      // Indikatoren: dezent, im Bild unten, mittig
                      if (_images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_images.length, (i) {
                              final active = i == _current;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 4,
                                width: active ? 28 : 14,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(active ? 1.0 : 0.7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              );
                            }),
                          ),
                        ),

                      // Tap auf Bild -> Artikel öffnen
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== Meta-Zeile =================================================
              Text(
                meta,
                style: const TextStyle(
                  fontSize: 12.5,
                  letterSpacing: 1.0,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                ),
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
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 28, // größer, wie im Beispiel
                    height: 1.12,
                    fontWeight: FontWeight.w800, // markant
                  ),
                ),
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
