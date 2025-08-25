import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/resilient_hotel_image.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key, required this.hotels});
  final List<Map<String, dynamic>> hotels;

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel>
    with AutomaticKeepAliveClientMixin {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, keepPage: true);
    // Prefetch ảnh đầu & trang kế
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAround(0);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _prefetch(String url) {
    if (!mounted) return;
    final provider = CachedNetworkImageProvider(url);
    precacheImage(provider, context);
  }

  void _prefetchAround(int index) {
    // i, i+1, i-1 (nếu có)
    final list = widget.hotels;
    void pre(int i) {
      if (i >= 0 && i < list.length) {
        final url = list[i]['image'] as String;
        _prefetch(url);
      }
    }

    pre(index);
    pre(index + 1);
    pre(index - 1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            allowImplicitScrolling: true, // ✳ mượt khi lướt nhanh
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              // Prefetch ảnh trang kế bên
              _prefetchAround(index);
            },
            itemCount: widget.hotels.length,
            itemBuilder: (context, index) {
              final hotel = widget.hotels[index];
              return _FeaturedCard(
                hotel: hotel,
                onTap: () => context.push('/hotel/${hotel['id']}'),
              );
            },
          ),
        ),
        const Gap(8),
        _PageIndicator(
          itemCount: widget.hotels.length,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.hotel, required this.onTap});
  final Map<String, dynamic> hotel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                  tag: 'hotel-image-${hotel['id']}',
                  child: Semantics(
                    label:
                        'Featured hotel image, ${hotel['title']}, ${hotel['location']}',
                    image: true,
                    child: ResilientHotelImage(
                        imageUrl: hotel['image'], fit: BoxFit.cover),
                  )),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .6)
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'hotel-title-${hotel['id']}',
                      flightShuttleBuilder: (ctx, anim, dir, from, to) =>
                          to.widget, // đơn giản
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          hotel['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      hotel['location'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: .8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.itemCount, required this.currentIndex});
  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Carousel position ${currentIndex + 1} of $itemCount',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (i) {
          final active = i == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: active ? 18 : 6,
            decoration: BoxDecoration(
              color: active ? cs.primary : cs.outlineVariant,
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }),
      ),
    );
  }
}
