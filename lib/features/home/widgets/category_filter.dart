import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (_, i) {
          final isSelected = selectedIndex == i;
          return ChoiceChip(
            label: Text(categories[i]),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(i),
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          );
        },
      ),
    );
  }
}
