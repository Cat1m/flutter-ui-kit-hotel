import 'package:flutter/material.dart';

typedef StickyBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class _StickyDelegate extends SliverPersistentHeaderDelegate {
  _StickyDelegate({
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.builder,
  });

  final double minExtentHeight;
  final double maxExtentHeight;
  final StickyBuilder builder;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      // Material để giữ shadow/ink nếu cần
      color: Theme.of(context).scaffoldBackgroundColor,
      child: builder(context, shrinkOffset, overlapsContent),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyDelegate oldDelegate) {
    return minExtent != oldDelegate.minExtent ||
        maxExtent != oldDelegate.maxExtent ||
        builder != oldDelegate.builder;
  }
}

/// Helper tiện dụng
SliverPersistentHeader stickyHeader({
  required double height,
  required StickyBuilder builder,
  bool pinned = true,
}) {
  return SliverPersistentHeader(
    pinned: pinned,
    delegate: _StickyDelegate(
      minExtentHeight: height,
      maxExtentHeight: height,
      builder: builder,
    ),
  );
}
