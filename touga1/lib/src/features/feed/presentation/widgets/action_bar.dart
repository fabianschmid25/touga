import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onProfile;

  const ActionBar({
    super.key,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: const Icon(Icons.favorite_border), onPressed: onLike),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: onComment,
        ),
        IconButton(icon: const Icon(Icons.share), onPressed: onShare),
        IconButton(
          icon: const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            radius: 14,
          ),
          onPressed: onProfile,
        ),
      ],
    );
  }
}
