// lib/core/widgets/atoms/rating_stars.dart
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.value, this.size = 16});
  final double value; // 0..5
  final double size;

  @override
  Widget build(BuildContext context) {
    final full = value.floor();
    final half = (value - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) return Icon(Icons.star, size: size);
        if (i == full && half) return Icon(Icons.star_half, size: size);
        return Icon(Icons.star_border, size: size);
      }),
    );
  }
}
