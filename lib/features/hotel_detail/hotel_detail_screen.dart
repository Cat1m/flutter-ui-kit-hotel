// lib/features/hotel_detail/hotel_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/rating_stars.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://picsum.photos/seed/detail$id/1200/700',
              fit: BoxFit.cover,
            ),
          ),
          const Gap(12),
          Text('Hotel #$id', style: Theme.of(context).textTheme.headlineSmall),
          const Gap(8),
          const RatingStars(value: 4.5, size: 20),
          const Gap(16),
          Text(
            'Amenity highlights: Free Wi‑Fi • Pool • Spa • Breakfast included',
          ),
          const Gap(24),
          FilledButton(onPressed: () {}, child: const Text('Select room')),
        ],
      ),
    );
  }
}
