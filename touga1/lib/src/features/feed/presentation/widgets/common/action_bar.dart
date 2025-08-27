import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final bool isExpanded;
  final Animation<double> animation;
  final VoidCallback onTap;
  final Color? buttonColor;

  const ActionBar({
    super.key,
    required this.isExpanded,
    required this.animation,
    required this.onTap,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          children: [
            // Haupt-Button
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: buttonColor ?? Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  't',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Expandierte Icons
            if (isExpanded) ...[
              const SizedBox(width: 12),
              ...List.generate(3, (index) {
                final icons = [Icons.favorite, Icons.share, Icons.bookmark];
                final labels = ['Liken', 'Teilen', 'Speichern'];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          icons[index],
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
