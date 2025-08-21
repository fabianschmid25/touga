import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaArea extends StatelessWidget {
  final List<String> images;
  final double? aspectRatio; // null = frei
  final double borderRadius;
  final bool showIndicators;
  final int currentIndex;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onTap;

  const MediaArea({
    super.key,
    required this.images,
    this.aspectRatio,
    this.borderRadius = 12,
    this.showIndicators = true,
    this.currentIndex = 0,
    this.onPageChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images.isNotEmpty)
            PageView.builder(
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
          else
            Container(color: const Color(0xFFE5E7EB)),
          if (showIndicators && images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final active = i == currentIndex;
                  return Container(
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
            ),
          if (onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: onTap),
              ),
            ),
        ],
      ),
    );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: content);
    }
    return content;
  }
}
