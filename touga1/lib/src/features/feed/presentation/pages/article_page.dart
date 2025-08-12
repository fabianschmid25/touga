import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom; // <- WICHTIG für dom.Element

import 'package:touga1/src/features/feed/domain/entities/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat.yMMMMd().format(dt);
  }

  int _estimateReadingTime(String htmlText) {
    final text = htmlText
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final words = text.isEmpty ? 0 : text.split(' ').length;
    return (words / 200).ceil().clamp(1, 60);
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroImage =
        (article.imageUrls.isNotEmpty) ? article.imageUrls.first : null;
    final readingMin = _estimateReadingTime(article.content);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            pinned: true,
            expandedHeight: heroImage != null ? 280 : 120,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: heroImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(heroImage, fit: BoxFit.cover),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(140, 0, 0, 0),
                                Color.fromARGB(60, 0, 0, 0),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.35, 1.0],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Text(
                                article.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.12,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black54,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (heroImage == null) ...[
                        const SizedBox(height: 4),
                        const SizedBox(height: 8),
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (article.subtitle.isNotEmpty) ...[
                        Text(
                          article.subtitle,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF475569),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _MetaBar(
                        dateLabel: _formatDate(article.createdAt),
                        readingMinutes: readingMin,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                          child: Html(
                            data: article.content,
                            style: {
                              "h1": Style(
                                fontSize: FontSize(30),
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                              "h2": Style(
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                              "h3": Style(
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                              "p": Style(
                                fontSize: FontSize(17),
                                color: const Color(0xFF1F2937),
                              ),
                              "li": Style(
                                fontSize: FontSize(17),
                                color: const Color(0xFF1F2937),
                              ),
                              "strong": Style(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                              "em": Style(fontStyle: FontStyle.italic),
                              "u": Style(
                                textDecoration: TextDecoration.underline,
                              ),
                              "a": Style(
                                color: const Color(0xFF2563EB),
                                textDecoration: TextDecoration.underline,
                              ),
                              "blockquote": Style(
                                backgroundColor: const Color(0xFFF1F5F9),
                              ),
                              "code": Style(
                                fontFamily: 'monospace',
                                backgroundColor: const Color(0xFFF3F4F6),
                                color: const Color(0xFF111827),
                              ),
                              "pre": Style(
                                fontFamily: 'monospace',
                                backgroundColor: const Color(0xFF0F172A),
                                color: Colors.white,
                              ),
                            },

                            // <- WICHTIG: alte Signatur (3 Parameter)
                            onLinkTap: (String? url,
                                Map<String, String> attributes,
                                dom.Element? element) {
                              if (url != null) _openLink(url);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBar extends StatelessWidget {
  final String dateLabel;
  final int readingMinutes;
  const _MetaBar({
    required this.dateLabel,
    required this.readingMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        if (dateLabel.isNotEmpty)
          const Icon(Icons.calendar_today_rounded,
              size: 14, color: Color(0xFF475569)),
        if (dateLabel.isNotEmpty)
          Text(
            dateLabel,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
        const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF475569)),
        Text(
          '$readingMinutes Min. Lesezeit',
          style: const TextStyle(
            color: Color(0xFF334155),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
