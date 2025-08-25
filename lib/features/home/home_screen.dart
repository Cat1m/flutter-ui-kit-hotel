import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/models/hotel.dart';
import 'package:flutter_ui_kit_hotel/core/models/result.dart';
import 'package:flutter_ui_kit_hotel/core/repositories/fake_hotel_repository.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/skeletons/featured_carousel_skeleton.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/skeletons/popular_list_skeleton.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/states/empty_state.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/states/error_state.dart';
import 'package:flutter_ui_kit_hotel/features/home/sections/popular_list_sliver.dart';
import 'package:flutter_ui_kit_hotel/features/home/widgets/sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/features/home/widgets/search_field.dart';
import 'package:flutter_ui_kit_hotel/features/home/widgets/category_filter.dart';
import 'package:flutter_ui_kit_hotel/features/home/widgets/section_header.dart';
import 'package:flutter_ui_kit_hotel/features/home/widgets/custom_bottom_navigation.dart';
import 'package:flutter_ui_kit_hotel/features/home/sections/featured_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _categoryVN = ValueNotifier<int>(0);
  final _repo = FakeHotelRepository();
  final int _selectedCategory = 0;
  int _navIndex = 0;
  final _storageKey = const PageStorageKey('home-list');

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

  late Future<Result<List<Hotel>>> _featuredFuture;
  late Future<Result<List<Hotel>>> _popularFuture;

  @override
  void initState() {
    super.initState();
    _reload(); // default category index 0
    // Khi categoryVN đổi -> reload futures mà không rebuild cả cây
    _categoryVN.addListener(() {
      setState(_reload);
    });
  }

  @override
  void dispose() {
    _categoryVN.dispose();
    super.dispose();
  }

  void _reload() {
    final idx = _categoryVN.value;
    final category = _categories[idx];
    _featuredFuture = _repo.fetchFeatured(category);
    _popularFuture = _repo.fetchPopular(category);
  }

  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final category = _categories[_selectedCategory];

    return Scaffold(
      appBar: null, // dùng SliverAppBar phía dưới
      body: CustomScrollView(
        key: _storageKey,
        cacheExtent: 800,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            elevation: 0,
            title: const Text('Explore stays'),
            centerTitle: true,
          ),

          // Search Field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SearchField(onTap: () => context.go('/search')),
            ),
          ),

          // Sticky Category Filter
          stickyHeader(
            height: 56,
            builder: (ctx, shrink, overlap) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).scaffoldBackgroundColor,
                  boxShadow: overlap
                      ? [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: .05),
                              blurRadius: 6,
                              offset: const Offset(0, 2))
                        ]
                      : [],
                ),
                child: ValueListenableBuilder<int>(
                  valueListenable: _categoryVN,
                  builder: (_, selected, __) => CategoryFilter(
                    categories: _categories,
                    selectedIndex: selected,
                    onCategorySelected: (i) => _categoryVN.value = i,
                  ),
                ),
              );
            },
          ),

          // Featured header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: SectionHeader(
                title: 'Featured',
                onSeeAllPressed: () =>
                    context.push('/list?section=featured&category=$category'),
              ),
            ),
          ),

          // Featured content with FutureBuilder
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<Result<List<Hotel>>>(
                future: _featuredFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const FeaturedCarouselSkeleton();
                  }
                  final res = snapshot.data!;
                  if (res is Failure<List<Hotel>>) {
                    return ErrorState(
                      message: 'Could not load featured stays.',
                      onRetry: () => setState(_reload),
                    );
                  }
                  final data = (res as Success<List<Hotel>>).data;
                  if (data.isEmpty) {
                    return const EmptyState(
                        message:
                            'No featured stays found. Try another category.');
                  }
                  // map về cấu trúc cũ cho FeaturedCarousel
                  final mapped = data
                      .map((h) => {
                            'id': h.id,
                            'title': h.title,
                            'image': h.imageUrl,
                            'price': h.price,
                            'rating': h.rating,
                            'location': h.location,
                            'category': h.category,
                          })
                      .toList();
                  return FeaturedCarousel(hotels: mapped);
                },
              ),
            ),
          ),

          // Popular header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: SectionHeader(
                title: 'Popular near you',
                onSeeAllPressed: () =>
                    context.push('/list?section=popular&category=$category'),
              ),
            ),
          ),

          // Popular content with FutureBuilder (Sliver)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder<Result<List<Hotel>>>(
              future: _popularFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const PopularListSkeleton(count: 6).build(context);
                }
                final res = snapshot.data!;
                if (res is Failure<List<Hotel>>) {
                  return SliverToBoxAdapter(
                    child: ErrorState(
                      message: 'Could not load popular stays.',
                      onRetry: () => setState(_reload),
                    ),
                  );
                }
                final data = (res as Success<List<Hotel>>).data;
                if (data.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                        message:
                            'No popular stays nearby. Try widening your search.'),
                  );
                }
                final mapped = data
                    .map((h) => {
                          'id': h.id,
                          'title': h.title,
                          'image': h.imageUrl,
                          'price': h.price,
                          'rating': h.rating,
                          'location': h.location,
                          'category': h.category,
                        })
                    .toList();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  for (var i = 0; i < mapped.length && i < 3; i++) {
                    final url = mapped[i]['image'] as String;
                    precacheImage(CachedNetworkImageProvider(url), context);
                  }
                });
                return PopularListSliver(hotels: mapped);
              },
            ),
          ),

          // Spacer cho bottom nav
          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _navIndex,
        onDestinationSelected: (i) {
          setState(() => _navIndex = i);
          _handleNavigation(context, i);
        },
      ),
    );
  }
}
