import 'package:flutter/material.dart';

/// Minimale Rubriken‑Leiste
class CategoriesBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  const CategoriesBar({
    Key? key,
    required this.selectedIndex,
    required this.onCategorySelected,
  }) : super(key: key);

  static const _labels = ['ForYou', 'Follow', 'Sport', 'News'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_labels.length, (i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onCategorySelected(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _labels[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(height: 2, width: 20, color: Colors.white),
              ],
            ),
          );
        }),
      ),
    );
  }
}
