import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HotelCardSkeleton extends StatelessWidget {
  const HotelCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surfaceContainerHighest,
      highlightColor: cs.surfaceContainerHigh,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: .2)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
                width: 110,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 16, width: 180, color: Colors.white),
                  Container(height: 14, width: 120, color: Colors.white),
                  Row(children: [
                    Container(height: 12, width: 60, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(height: 12, width: 80, color: Colors.white),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
