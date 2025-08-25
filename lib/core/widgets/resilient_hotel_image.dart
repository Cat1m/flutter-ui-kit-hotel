import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/services/hotel_image_service.dart';

class ResilientHotelImage extends StatefulWidget {
  const ResilientHotelImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.enableLogging = false, // mặc định tắt log để giảm noise
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
    _initFallbacks();
  }

  void _initFallbacks() {
    _fallbackUrls = [
      widget.imageUrl,
      HotelImageService.reliablePicsumImage(
          seed: 'fallback-${widget.imageUrl.hashCode}',
          width: 1000,
          height: 600),
      HotelImageService.jsonPlaceholderPhoto(
          seed: 'fallback2-${widget.imageUrl.hashCode}',
          width: 1000,
          height: 600),
      ...HotelImageService.getFallbackImages(width: 1000, height: 600),
    ];
  }

  String? get _currentUrl => _fallbackStage >= _fallbackUrls.length
      ? null
      : _fallbackUrls[_fallbackStage];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_currentUrl == null) {
      return Container(
        color: theme.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined,
            size: 48, color: theme.colorScheme.onSurfaceVariant),
      );
    }

    // Dùng LayoutBuilder để tính memCacheWidth ~= pixel thực tế
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.of(context).devicePixelRatio;
        // chiều rộng pixel hợp lý, clamp tránh 0 hoặc quá lớn
        final memWidth = (constraints.maxWidth.isFinite
                ? (constraints.maxWidth * dpr)
                : MediaQuery.of(context).size.width * dpr)
            .clamp(320.0, 1600.0)
            .round();

        return CachedNetworkImage(
          imageUrl: _currentUrl!,
          fit: widget.fit,
          memCacheWidth: memWidth,
          placeholder: (context, url) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: theme.colorScheme.primary),
          ),
          errorWidget: (context, url, err) {
            // fallback tiếp
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _fallbackStage < _fallbackUrls.length - 1) {
                setState(() => _fallbackStage++);
              }
            });
            return const SizedBox.shrink();
          },
          imageBuilder: (context, imageProvider) => DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: widget.fit),
            ),
          ),
        );
      },
    );
  }
}
