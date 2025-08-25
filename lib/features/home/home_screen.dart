// lib/features/home/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/molecules/hotel_card.dart';
import 'package:flutter_ui_kit_hotel/core/services/hotel_image_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _faker = Faker();
  int _selectedCategory = 0;
  int _navIndex = 0;

  static const List<String> _categories = [
    'All',
    'Beach',
    'City',
    'Business',
    'Family',
    'Romantic',
    'Budget',
    'Luxury',
  ];

  // ---- Hotel Image Service Integration ----------------------------------
  String _getHotelImage(String seed, {String? category}) {
    if (category != null && category != 'All') {
      return HotelImageHelper.getCategoryImage(seed, category, 1000, 600);
    }
    return HotelImageService.diverseHotelImage(
        seed: seed, width: 1000, height: 600);
  }

  // ---- Fake Data Generation ----------------------------------------------
  List<Map<String, dynamic>> _generateHotels(int count,
      {required String seedPrefix}) {
    final selectedCategory = _categories[_selectedCategory];

    return List.generate(count, (index) {
      final city = _faker.address.city();
      final hotelSeed = '$seedPrefix-$index';

      return {
        'id': hotelSeed,
        'title': _faker.company.name(),
        'image': _getHotelImage(hotelSeed, category: selectedCategory),
        'price': '\$${120 + (index * 15)}/night',
        'rating': (3.5 + (index % 3) * 0.5).clamp(3.0, 5.0),
        'location': city,
        'category': selectedCategory,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate data based on selected category
    final featuredHotels = _generateHotels(5, seedPrefix: 'featured');
    final popularHotels = _generateHotels(6, seedPrefix: 'popular');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore stays'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Field
          _SearchField(onTap: () => context.go('/search')),
          const Gap(16),

          // Category Filter
          _CategoryFilter(
            categories: _categories,
            selectedIndex: _selectedCategory,
            onCategorySelected: (index) {
              setState(() => _selectedCategory = index);
            },
          ),
          const Gap(20),

          // Featured Section
          _SectionHeader(
            title: 'Featured',
            onSeeAllPressed: () {
              // Navigate to featured list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Featured hotels (UI coming soon)')),
              );
            },
          ),
          const Gap(8),
          _FeaturedCarousel(hotels: featuredHotels),
          const Gap(20),

          // Popular Section
          _SectionHeader(
            title: 'Popular near you',
            onSeeAllPressed: () {
              // Navigate to popular list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Popular hotels (UI coming soon)')),
              );
            },
          ),
          const Gap(8),

          // Popular Hotels List
          ...popularHotels.map((hotel) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HotelCard(
                  id: hotel['id'],
                  title: hotel['title'],
                  imageUrl: hotel['image'],
                  price: hotel['price'],
                  rating: hotel['rating'],
                  location: hotel['location'],
                  onTap: () => context.push('/hotel/${hotel['id']}'),
                ),
              )),

          const Gap(100), // Space for bottom navigation
        ],
      ),
      bottomNavigationBar: _CustomBottomNavigation(
        currentIndex: _navIndex,
        onDestinationSelected: (index) {
          setState(() => _navIndex = index);
          _handleNavigation(context, index);
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
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
  }
}

// ==================== Search Field Widget ====================
class _SearchField extends StatelessWidget {
  const _SearchField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
          color: colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
            ),
            const Gap(8),
            Text(
              'Where to?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.tune_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Category Filter Widget ====================
class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(index),
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          );
        },
      ),
    );
  }
}

// ==================== Section Header Widget ====================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.onSeeAllPressed,
  });

  final String title;
  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text(
              'See all',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

// ==================== Featured Carousel Widget ====================
class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel({required this.hotels});

  final List<Map<String, dynamic>> hotels;

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
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

// ==================== Featured Card Widget ====================
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.hotel,
    required this.onTap,
  });

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
              // Hotel Image
              ResilientHotelImage(
                imageUrl: hotel['image'],
                fit: BoxFit.cover,
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),

              // Hotel Info
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hotel['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      hotel['location'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
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

// ==================== Page Indicator Widget ====================
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 18 : 6,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

// ==================== Custom Bottom Navigation ====================
class _CustomBottomNavigation extends StatelessWidget {
  const _CustomBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Explore',
        ),
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
    );
  }
}

// ==================== Resilient Hotel Image Widget ====================
class ResilientHotelImage extends StatefulWidget {
  const ResilientHotelImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.enableLogging = true,
  });

  final String imageUrl;
  final BoxFit fit;
  final bool enableLogging;

  @override
  State<ResilientHotelImage> createState() => _ResilientHotelImageState();
}

class _ResilientHotelImageState extends State<ResilientHotelImage> {
  int _fallbackStage = 0;
  late List<String> _fallbackUrls;

  @override
  void initState() {
    super.initState();
    _initializeFallbackUrls();
  }

  void _initializeFallbackUrls() {
    _fallbackUrls = [
      widget.imageUrl, // Original URL
      // Reliable Picsum fallbacks
      HotelImageService.reliablePicsumImage(
        seed: 'fallback-${widget.imageUrl.hashCode}',
        width: 1000,
        height: 600,
      ),
      HotelImageService.jsonPlaceholderPhoto(
        seed: 'fallback2-${widget.imageUrl.hashCode}',
        width: 1000,
        height: 600,
      ),
      // Guaranteed working fallbacks
      ...HotelImageService.getFallbackImages(width: 1000, height: 600),
    ];
  }

  void _logError(
      String stage, String url, Object error, StackTrace? stackTrace) {
    if (!widget.enableLogging) return;

    print('🖼️ [HotelImage] $stage Error:');
    print('   URL: $url');
    print('   Error: $error');
    print('   Fallback Stage: $_fallbackStage/${_fallbackUrls.length}');
    if (stackTrace != null) {
      print('   StackTrace: $stackTrace');
    }
    print('   ---');
  }

  void _logSuccess(String stage, String url) {
    if (!widget.enableLogging) return;

    print('✅ [HotelImage] $stage Success:');
    print('   URL: $url');
    print('   Fallback Stage: $_fallbackStage/${_fallbackUrls.length}');
    print('   ---');
  }

  String? get _currentImageUrl {
    if (_fallbackStage >= _fallbackUrls.length) {
      return null;
    }
    return _fallbackUrls[_fallbackStage];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUrl = _currentImageUrl;

    if (currentUrl == null) {
      if (widget.enableLogging) {
        print('💥 [HotelImage] All fallbacks failed for: ${widget.imageUrl}');
      }
      return Container(
        color: theme.colorScheme.surfaceVariant,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              if (widget.enableLogging) ...[
                const SizedBox(height: 4),
                Text(
                  'Image failed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: currentUrl,
      fit: widget.fit,
      memCacheWidth: 1000,
      placeholder: (context, url) {
        if (widget.enableLogging && _fallbackStage == 0) {
          print('⏳ [HotelImage] Loading: $url');
        }
        return Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        // Log the specific error
        _logError('CacheNetwork', url, error, null);

        // Try next fallback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _fallbackStage < _fallbackUrls.length - 1) {
            setState(() {
              _fallbackStage++;
              if (widget.enableLogging) {
                print(
                    '🔄 [HotelImage] Trying fallback stage $_fallbackStage: ${_fallbackUrls[_fallbackStage]}');
              }
            });
          }
        });

        return const SizedBox.shrink();
      },
      // Add success callback for debugging
      imageBuilder: (context, imageProvider) {
        _logSuccess('CacheNetwork', currentUrl);
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: widget.fit,
            ),
          ),
        );
      },
    );
  }
}
