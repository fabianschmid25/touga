import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MetaLinePills extends StatelessWidget {
  final String author;
  final List<String> categories;
  final String? authorAvatarUrl;

  const MetaLinePills({
    super.key,
    required this.author,
    required this.categories,
    this.authorAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profilbild des Autors
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: authorAvatarUrl != null && authorAvatarUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: authorAvatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),

        // Autor mit kreativer Schriftart
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            author,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              fontFamily:
                  'SF Pro Display', // Moderne Schriftart (falls verfügbar)
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Kategorien rechts, einzeilig, abgeschnitten falls kein Platz
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              const double pillHPadding = 8;
              const double pillBorder = 1;
              const double spacing = 8;
              final double tolerance = 2.0;

              const TextStyle pillStyle = TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 0.8,
                fontFamily: 'SF Pro Display',
              );

              // Berechne die Breite des Autors (inkl. Profilbild)
              final authorTextPainter = TextPainter(
                text: TextSpan(
                  text: author,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                textDirection: TextDirection.ltr,
                maxLines: 1,
              )..layout();

              // Verfügbare Breite für Kategorien (abzüglich Autor + Profilbild + Spacing)
              final double availableWidth = maxWidth -
                  authorTextPainter.width -
                  40; // 24 (Profilbild) + 16 (Spacing)

              if (availableWidth <= 0) {
                return const SizedBox.shrink();
              }

              double usedWidth = 0;
              final List<Widget> children = [];

              for (int i = 0; i < categories.length; i++) {
                final label = categories[i].toUpperCase();

                final tp = TextPainter(
                  text: TextSpan(text: label, style: pillStyle),
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                )..layout();

                final double pillWidth =
                    tp.width + (pillHPadding * 2) + (pillBorder * 2);
                final double nextWidth = usedWidth == 0
                    ? pillWidth
                    : usedWidth + spacing + pillWidth;

                if (nextWidth <= availableWidth + tolerance) {
                  if (usedWidth != 0) {
                    children.add(const SizedBox(width: spacing));
                  }
                  children.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: pillHPadding,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: pillBorder,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF9FAFB),
                      ),
                      child: Text(label, style: pillStyle, maxLines: 1),
                    ),
                  );
                  usedWidth = nextWidth;
                } else {
                  if (i == 0 && pillWidth > availableWidth) {
                    final shortenedLabel = _shortenText(
                        label,
                        availableWidth - (pillHPadding * 2) - (pillBorder * 2),
                        pillStyle);
                    if (shortenedLabel.isNotEmpty) {
                      children.add(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: pillHPadding,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: pillBorder,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF9FAFB),
                          ),
                          child: Text(shortenedLabel,
                              style: pillStyle, maxLines: 1),
                        ),
                      );
                    }
                  }
                  break;
                }
              }

              return Row(children: children);
            },
          ),
        ),
      ],
    );
  }

  // Hilfsmethode zum Kürzen von Text basierend auf verfügbarer Breite
  String _shortenText(String text, double maxWidth, TextStyle style) {
    if (text.isEmpty) return '';

    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    if (tp.width <= maxWidth) return text;

    // Binäre Suche für optimale Länge
    int left = 0;
    int right = text.length;
    String result = '';

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      String testText = text.substring(0, mid);
      if (mid < text.length) testText += '…';

      final testTp = TextPainter(
        text: TextSpan(text: testText, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      if (testTp.width <= maxWidth) {
        result = testText;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return result;
  }
}
