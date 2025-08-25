import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedCarouselSkeleton extends StatelessWidget {
  const FeaturedCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 10),
          itemBuilder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.white),
          ),
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: 3,
        ),
      ),
    );
  }
}
