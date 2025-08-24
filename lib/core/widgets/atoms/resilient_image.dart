import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Ảnh mạng có retry/fallback cho picsum.photos:
/// - Lần 1: dùng URL gốc (thường là /seed/...).
/// - Lần 2 (fail): fallback sang /w/h random.
/// - Lần 3 (vẫn fail): hiện icon lỗi.
class ResilientImage extends StatefulWidget {
  const ResilientImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width = 800,
    this.height = 480,
    this.memCacheWidth,
  });

  final String url;
  final BoxFit fit;
  final int width; // dùng cho fallback /width/height
  final int height; // dùng cho fallback /width/height
  final int? memCacheWidth;

  @override
  State<ResilientImage> createState() => _ResilientImageState();
}

class _ResilientImageState extends State<ResilientImage> {
  int _stage = 0; // 0: original, 1: fallback random, 2: error icon

  String _fallbackRandom() =>
      'https://picsum.photos/${widget.width}/${widget.height}';

  @override
  Widget build(BuildContext context) {
    if (_stage >= 2) {
      return const Center(child: Icon(Icons.broken_image_outlined));
    }

    final imageUrl = _stage == 0 ? widget.url : _fallbackRandom();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: widget.fit,
      memCacheWidth: widget.memCacheWidth ?? widget.width,
      placeholder: (_, __) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      errorWidget: (_, __, ___) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _stage += 1);
        });
        return const SizedBox.shrink();
      },
    );
  }
}
