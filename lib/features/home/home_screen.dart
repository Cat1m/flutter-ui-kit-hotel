// lib/features/home/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/molecules/hotel_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _faker = Faker();
  int _selectedCategory = 0;
  int _navIndex = 0;

  List<String> get _categories => const [
        'All',
        'Beach',
        'City',
        'Business',
        'Family',
        'Romantic',
        'Budget',
        'Luxury',
      ];

  // ---- Picsum helpers -------------------------------------------------------
  String _picsumSeed(String seed, int w, int h) =>
      'https://picsum.photos/seed/${Uri.encodeComponent(seed)}/$w/$h';

  // ---- Fake data -------------------------------------------------------------
  List<Map<String, dynamic>> _genHotels(int n, {String seed = 'hotel'}) {
    return List.generate(n, (i) {
      final city = _faker.address.city();
      final s = '$seed-$i';
      return {
        'id': s,
        'title': _faker.company.name(),
        'image': _picsumSeed(s, 1000, 600), // ảnh ổn định theo seed
        'price': '\$${120 + (i * 15)}/night',
        'rating': 3.5 + (i % 3) * 0.5,
        'location': city,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final featured = _genHotels(5, seed: 'feat');
    final popular = _genHotels(6, seed: 'pop');

    return Scaffold(
      appBar: AppBar(title: const Text('Explore stays'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search field
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.go('/search'),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const Gap(8),
                  Text('Where to?',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  const Icon(Icons.tune_rounded),
                ],
              ),
            ),
          ),
          const Gap(16),

          // Categories
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (ctx, i) {
                final selected = _selectedCategory == i;
                return ChoiceChip(
                  label: Text(_categories[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = i),
                );
              },
            ),
          ),
          const Gap(20),

          // Featured carousel
          const _SectionTitle(title: 'Featured'),
          const Gap(8),
          _FeaturedCarousel(items: featured),
          const Gap(20),

          // Popular list
          const _SectionTitle(title: 'Popular near you'),
          const Gap(8),
          ...popular.map(
            (h) => HotelCard(
              id: h['id'],
              title: h['title'],
              imageUrl: h['image'],
              price: h['price'],
              rating: h['rating'],
              location: h['location'],
              onTap: () => context.push('/hotel/${h['id']}'),
            ),
          ),
          const Gap(100), // space for nav bar
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (idx) {
          setState(() => _navIndex = idx);
          switch (idx) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/booking');
              break;
            case 3:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile (UI coming soon)')),
              );
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text('See all')),
      ],
    );
  }
}

// ==================== Featured Carousel ====================

class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel({required this.items});
  final List<Map<String, dynamic>> items;

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: widget.items.length,
            itemBuilder: (ctx, i) {
              final h = widget.items[i];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => context.push('/hotel/${h['id']}'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PicsumImage(url: h['image'], fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: .6),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                const Gap(4),
                                Text(
                                  h['location'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 18 : 6,
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ==================== Picsum resilient image ====================

class PicsumImage extends StatefulWidget {
  const PicsumImage({super.key, required this.url, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  State<PicsumImage> createState() => _PicsumImageState();
}

class _PicsumImageState extends State<PicsumImage> {
  // 0 = dùng seed URL gốc; 1 = retry sang random /w/h; 2 = icon lỗi
  int _stage = 0;

  String _fallbackRandom() => 'https://picsum.photos/1000/600';

  @override
  Widget build(BuildContext context) {
    final displayUrl = switch (_stage) {
      0 => widget.url,
      1 => _fallbackRandom(),
      _ => '',
    };

    if (_stage >= 2) {
      return const Center(child: Icon(Icons.broken_image_outlined));
    }

    return CachedNetworkImage(
      imageUrl: displayUrl,
      fit: widget.fit,
      memCacheWidth: 1000,
      placeholder: (_, __) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      errorWidget: (_, __, ___) {
        // lần đầu fail (404/503) → thử random endpoint
        // lần hai vẫn fail → icon lỗi
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _stage += 1);
        });
        return const SizedBox.shrink();
      },
    );
  }
}
