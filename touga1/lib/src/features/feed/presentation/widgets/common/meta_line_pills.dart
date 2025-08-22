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
              final double tolerance = MediaQuery.of(context).devicePixelRatio;

              const TextStyle pillStyle = TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              );

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

                if (nextWidth <= maxWidth + tolerance) {
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
                  break; // keine weitere Pille, um zweite Zeile/Überlauf zu vermeiden
                }
              }

              return Row(children: children);
            },
          ),
        ),
      ],
    );
  }
}
