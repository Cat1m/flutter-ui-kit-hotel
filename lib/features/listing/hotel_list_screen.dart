import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/models/hotel.dart';
import 'package:flutter_ui_kit_hotel/core/models/result.dart';
import 'package:flutter_ui_kit_hotel/core/repositories/fake_hotel_repository.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/molecules/hotel_card.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/skeletons/popular_list_skeleton.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/states/empty_state.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/states/error_state.dart';
import 'package:flutter_ui_kit_hotel/core/state/app_state.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen(
      {super.key, required this.section, required this.category});
  final String section; // 'featured' | 'popular'
  final String category; // current category from Home

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  final _repo = FakeHotelRepository();
  late Future<Result<List<Hotel>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Result<List<Hotel>>> _load() {
    return widget.section == 'popular'
        ? _repo.fetchPopular(widget.category)
        : _repo.fetchFeatured(widget.category);
  }

  String get _title {
    final sec = widget.section == 'popular' ? 'Popular' : 'Featured';
    return '$sec · ${widget.category}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<Result<List<Hotel>>>(
              future: _future,
              builder: (context, snap) {
                if (!snap.hasData) return const PopularListSkeleton(count: 8);

                final res = snap.data!;
                if (res is Failure<List<Hotel>>) {
                  return SliverToBoxAdapter(
                    child: ErrorState(
                      message: 'Could not load ${widget.section} stays.',
                      onRetry: () => setState(() => _future = _load()),
                    ),
                  );
                }

                final items = (res as Success<List<Hotel>>).data;
                if (items.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                        message:
                            'No stays found. Try changing category or dates.'),
                  );
                }

                return SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final h = items[i];
                    // Nếu HotelCard có enableHero & trailingAction:
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: i == items.length - 1 ? 0 : 8),
                      child: Stack(
                        children: [
                          HotelCard(
                            id: h.id,
                            title: h.title,
                            imageUrl: h.imageUrl,
                            price: h.price,
                            rating: h.rating,
                            location: h.location,
                            // enableHero: true, // nếu bạn đã thêm prop này
                            onTap: () => context.push(
                                '/hotel/${h.id}?title=${Uri.encodeComponent(h.title)}&image=${Uri.encodeComponent(h.imageUrl)}'),
                          ),
                          // ♥ nút nổi góc phải ảnh (mock nhanh nếu HotelCard chưa hỗ trợ)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ValueListenableBuilder<Set<String>>(
                              valueListenable: AppState.favorites,
                              builder: (_, favs, __) {
                                final liked = favs.contains(h.id);
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () => AppState.toggleFav(h.id),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        liked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            liked ? Colors.pink : Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
