import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/state/app_state.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/molecules/hotel_card.dart';
import 'package:go_router/go_router.dart';

class PopularListSliver extends StatelessWidget {
  const PopularListSliver({super.key, required this.hotels});
  final List<Map<String, dynamic>> hotels;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final h = hotels[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == hotels.length - 1 ? 0 : 8),
              child: HotelCard(
                id: h['id'],
                title: h['title'],
                imageUrl: h['image'],
                price: h['price'],
                rating: h['rating'],
                location: h['location'],
                enableHero: true,
                showWishlist: true,
                isWishlisted: AppState.isFav(h['id']),
                onToggleWishlist: () => AppState.toggleFav(h['id']),
                onTap: () => context.push('/hotel/${h['id']}'),
              ),
            );
          },
          childCount: hotels.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: false, // ✳ giảm work khi list dài
        ),
      ),
    );
  }
}
