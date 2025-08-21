import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';
import '../pages/article_page.dart';
import '../widgets/common/headline.dart';
// import '../widgets/common/meta_line.dart';
import '../widgets/common/meta_line_pills.dart';
import '../widgets/common/media_area.dart';

class Card34View extends StatefulWidget {
  final Article article;
  final String? authorName;
  final List<String>? categories;

  const Card34View({
    super.key,
    required this.article,
    this.authorName,
    this.categories,
  });

  @override
  State<Card34View> createState() => _Card34ViewState();
}

class _Card34ViewState extends State<Card34View> {
  int _current = 0;

  double _headlineFontSize(String title) {
    final len = title.trim().length;
    if (len <= 45) return 32;
    if (len <= 70) return 28;
    return 24;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Höhe wird durch Expanded gesteuert; frühere fixe Höhe entfernt

    final displayAuthor = widget.authorName ?? 'Max Meyer';
    final displayCats =
        widget.categories ?? const ['Aktuelles', 'Reisen', 'Wandern'];

    final headlineText = widget.article.title.toUpperCase();

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 56,
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
                  MetaLinePills(author: displayAuthor, categories: displayCats),
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
                      maxLines: 3,
                    ),
                  ),
                  Expanded(flex: 15, child: SizedBox()),
                ],
              ),
            ),
            // ActionBar entfernt
          ],
        ),
      ),
    );
  }
}
