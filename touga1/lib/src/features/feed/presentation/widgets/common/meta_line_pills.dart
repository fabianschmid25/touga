import 'package:flutter/material.dart';

class MetaLinePills extends StatelessWidget {
  final String author;
  final List<String> categories;

  const MetaLinePills({
    super.key,
    required this.author,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Autor links, ellipsiert
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            author,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
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
              final double tolerance =
                  2.0; // Kleinerer Toleranzwert für präzisere Berechnung

              const TextStyle pillStyle = TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              );

              // Berechne die Breite des Autors, um den verfügbaren Platz für Kategorien zu bestimmen
              final authorTextPainter = TextPainter(
                text: TextSpan(
                  text: author,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                textDirection: TextDirection.ltr,
                maxLines: 1,
              )..layout();

              // Verfügbare Breite für Kategorien (abzüglich Autor + Spacing)
              final double availableWidth =
                  maxWidth - authorTextPainter.width - 8;

              if (availableWidth <= 0) {
                // Kein Platz für Kategorien
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

                // Prüfe, ob die Pille in den verfügbaren Platz passt
                if (nextWidth <= availableWidth + tolerance) {
                  if (usedWidth != 0) {
                    children.add(const SizedBox(width: spacing));
                  }
                  children.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: pillHPadding,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black, width: pillBorder),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(label, style: pillStyle, maxLines: 1),
                    ),
                  );
                  usedWidth = nextWidth;
                } else {
                  // Versuche, die Pille zu kürzen, falls sie nur knapp nicht passt
                  if (i == 0 && pillWidth > availableWidth) {
                    // Erste Pille ist zu breit - zeige sie gekürzt an
                    final shortenedLabel = _shortenText(
                        label,
                        availableWidth - (pillHPadding * 2) - (pillBorder * 2),
                        pillStyle);
                    if (shortenedLabel.isNotEmpty) {
                      children.add(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: pillHPadding,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: pillBorder),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(shortenedLabel,
                              style: pillStyle, maxLines: 1),
                        ),
                      );
                    }
                  }
                  break; // Keine weiteren Pillen
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
