import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/rating_stars.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/resilient_image.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    this.location,
    this.onTap,
  });
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final double rating;
  final String? location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ResilientImage(
                url: imageUrl, // có retry → /w/h nếu lỗi
                fit: BoxFit.cover,
                width: 800, // fallback size hợp lý cho card
                height: 450,
                memCacheWidth: 800, // cache gọn hơn nhưng vẫn nét
              ),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const Gap(4),
                  if (location != null)
                    Text(
                      location!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingStars(value: rating),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
