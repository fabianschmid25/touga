// lib/src/features/feed/presentation/widgets/action_bar.dart

import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';

class ActionBar extends StatelessWidget {
  final Article article;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ActionBar({
    Key? key,
    required this.article,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profilbild
        GestureDetector(
          onTap: onComment,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=${article.id}',
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Like (ohne Label)
        _IconButton(icon: Icons.favorite_border, onTap: onLike),
        const SizedBox(height: 24),

        // Kommentar (ohne Label)
        _IconButton(icon: Icons.chat_bubble_outline, onTap: onComment),
        const SizedBox(height: 24),

        // Share
        _IconButton(icon: Icons.share, onTap: onShare),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({Key? key, required this.icon, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
