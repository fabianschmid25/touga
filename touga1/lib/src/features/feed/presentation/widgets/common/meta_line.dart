import 'package:flutter/material.dart';

class MetaLine extends StatelessWidget {
  final String author;
  final List<String> categories;
  final TextStyle? style;

  const MetaLine({
    super.key,
    required this.author,
    required this.categories,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final upperAuthor = author.toUpperCase();
    final upperCats = categories.map((e) => e.toUpperCase()).toList();
    final text = upperCats.isNotEmpty
        ? '$upperAuthor / ${upperCats.join(' ')}'
        : upperAuthor;

    return Text(
      text,
      style: style ??
          const TextStyle(
            fontSize: 12.5,
            letterSpacing: 1.0,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w700,
          ),
    );
  }
}
