import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const Headline({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style ??
          const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 28,
            height: 1.12,
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
