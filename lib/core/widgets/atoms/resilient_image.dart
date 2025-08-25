import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Ảnh mạng có retry/fallback:
/// - Stage 0: dùng URL gốc.
/// - Stage 1: fallback sang picsum.photos /width/height (random).
/// - Stage 2+: hiện icon lỗi.
/// Ứng xử bộ nhớ: memCacheWidth được tính động theo kích thước layout thực tế
/// (nếu không truyền memCacheWidth thủ công).
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

  /// Kích thước gợi ý khi fallback (picsum) & khi không đo được layout
  final int width;
  final int height;

  /// Nếu không truyền, component sẽ tự tính theo LayoutBuilder * devicePixelRatio
  final int? memCacheWidth;

  @override
  State<ResilientImage> createState() => _ResilientImageState();
}

class _ResilientImageState extends State<ResilientImage> {
  int _stage = 0; // 0: original, 1: fallback random, 2+: error icon

  String _fallbackRandom() =>
      'https://picsum.photos/${widget.width}/${widget.height}';

  @override
  Widget build(BuildContext context) {
    // Khi đã quá số lần fallback -> icon lỗi
    if (_stage >= 2) {
      return Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    final imageUrl = _stage == 0 ? widget.url : _fallbackRandom();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính memCacheWidth động dựa trên kích thước thực và DPI
        final dpr = MediaQuery.of(context).devicePixelRatio;
        final double logicalW =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : widget.width.toDouble();
        final computedMemW = (logicalW * dpr).clamp(320.0, 1600.0).round();

        return CachedNetworkImage(
          key: ValueKey('resilient-$imageUrl-$_stage'),
          imageUrl: imageUrl,
          fit: widget.fit,
          memCacheWidth: widget.memCacheWidth ?? computedMemW,
          fadeInDuration: const Duration(milliseconds: 120),
          fadeOutDuration: const Duration(milliseconds: 120),
          placeholder: (_, __) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          errorWidget: (_, __, ___) {
            // Thử stage kế tiếp ở frame sau để tránh setState trong build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() => _stage += 1);
            });
            return const SizedBox.shrink();
          },
          // imageBuilder giữ nguyên để tận dụng decoration ngoài nếu cần
          // imageBuilder: (ctx, provider) => DecoratedBox(
          //   decoration: BoxDecoration(image: DecorationImage(image: provider, fit: widget.fit)),
          // ),
        );
      },
    );
  }
}
