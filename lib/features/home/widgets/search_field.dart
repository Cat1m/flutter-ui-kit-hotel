import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: .5)),
          color: cs.surface,
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: cs.onSurfaceVariant),
            const Gap(8),
            Text('Where to?',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const Spacer(),
            Icon(Icons.tune_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
