import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/skeletons/hotel_card_skeleton.dart';

class PopularListSkeleton extends StatelessWidget {
  const PopularListSkeleton({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        itemCount: count,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 8),
          child: const HotelCardSkeleton(),
        ),
      ),
    );
  }
}
