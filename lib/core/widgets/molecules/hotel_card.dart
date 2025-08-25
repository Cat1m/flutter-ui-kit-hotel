import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/utils/price_formatter.dart';
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

    // ✳️ mới: Hero & Wishlist
    this.enableHero = false,
    this.showWishlist = false,
    this.isWishlisted = false,
    this.onToggleWishlist,

    // ✳ i18n
    this.locale = 'en_US',
    this.currency = 'USD',
  });

  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final double rating;
  final String? location;
  final VoidCallback? onTap;

  /// ✳️ Hero cho ảnh + tiêu đề
  final bool enableHero;

  /// ✳️ Hiện nút ♥ trên ảnh
  final bool showWishlist;
  final bool isWishlisted;
  final VoidCallback? onToggleWishlist;
  final String locale;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Cố gắng parse giá nếu repo trả chuỗi "$135/night"
    String priceText = price;
    final num? parsed = _tryParsePrice(price);
    if (parsed != null) {
      priceText =
          '${PriceFormatter.format(parsed, currency: currency, locale: locale)}/night';
    }

    return Semantics(
      label: 'Hotel: $title, rating $rating'
          '${location != null ? ', location $location' : ''}'
          ', price $priceText',
      button: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1.5,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    enableHero
                        ? Hero(tag: 'hotel-image-$id', child: _image(context))
                        : _image(context),
                    // Gradient là trang trí -> loại khỏi semantics
                    ExcludeSemantics(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withValues(alpha: .25),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (showWishlist)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Semantics(
                          button: true,
                          label: isWishlisted
                              ? 'Remove from wishlist'
                              : 'Add to wishlist',
                          onTapHint: isWishlisted
                              ? 'Double tap to remove from wishlist'
                              : 'Double tap to add to wishlist',
                          child: _FavButton(
                              isActive: isWishlisted, onTap: onToggleWishlist),
                        ),
                      ),
                  ],
                ),
              ),

              // Texts
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    enableHero
                        ? Hero(
                            tag: 'hotel-title-$id',
                            flightShuttleBuilder: (ctx, a, d, f, t) => t.widget,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          )
                        : Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                    const Gap(4),
                    if (location != null)
                      Text(
                        location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStars(value: rating),
                        Text(
                          priceText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
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
      ),
    );
  }

  num? _tryParsePrice(String raw) {
    // Tìm số đầu tiên: "$135/night" -> 135
    final m = RegExp(r'(\d+(\.\d+)?)').firstMatch(raw);
    if (m == null) return null;
    return num.tryParse(m.group(1)!);
  }

  Widget _image(BuildContext context) {
    // Gợi ý memCacheWidth theo width thực tế sẽ làm ở ResilientImage nếu cần,
    // ở đây giữ nguyên thông số bạn đang dùng.
    return ResilientImage(
      url: imageUrl,
      fit: BoxFit.cover,
      width: 800,
      height: 450,
      memCacheWidth: 800,
    );
  }
}

/// Nút ♥ với nền mờ, bo tròn, chạm dễ.
class _FavButton extends StatelessWidget {
  const _FavButton({required this.isActive, this.onTap});
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isActive ? Icons.favorite : Icons.favorite_border,
            color: isActive ? Colors.pinkAccent : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
