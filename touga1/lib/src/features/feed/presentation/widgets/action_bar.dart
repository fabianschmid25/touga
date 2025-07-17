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
        // Profilbild oben
        GestureDetector(
          onTap: onComment, // z.B. Profilseite oder Kommentar öffnen
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              // Platzhalter‑URL oder später echtes Nutzerbild
              'https://i.pravatar.cc/150?u=${article.id}',
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Like
        _IconButton(
          icon: Icons.favorite_border,
          label: article.likesCount?.toString() ?? '0',
          onTap: onLike,
        ),
        const SizedBox(height: 24),

        // Kommentar
        _IconButton(
          icon: Icons.chat_bubble_outline,
          label: article.commentsCount?.toString() ?? '0',
          onTap: onComment,
        ),
        const SizedBox(height: 24),

        // Share
        _IconButton(icon: Icons.share, onTap: onShare),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _IconButton({
    Key? key,
    required this.icon,
    this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
