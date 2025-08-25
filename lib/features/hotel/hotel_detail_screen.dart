import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/state/app_state.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen(
      {super.key, required this.id, this.title, this.imageUrl});
  final String id;
  final String? title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'hotel-title-$id',
          child: Material(
            type: MaterialType.transparency,
            child: Text(title ?? 'Hotel'),
          ),
        ),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: AppState.favorites,
            builder: (_, favs, __) {
              final liked = favs.contains(id);
              return IconButton(
                onPressed: () => AppState.toggleFav(id),
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.pink : cs.onSurface),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl == null
                ? Container(color: cs.surfaceContainerHighest)
                : Hero(
                    tag: 'hotel-image-$id',
                    child: Image.network(imageUrl!, fit: BoxFit.cover),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title ?? 'Hotel',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          // … thêm mô tả/tiện nghi/đánh giá/CTA đặt phòng sau
        ],
      ),
    );
  }
}
