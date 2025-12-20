import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yume_app/core/theme/app_colors.dart';

class SliverShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const SliverShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childCount: itemCount,
        itemBuilder: (context, index) {
          // Randomized heights for staggered look
          final height = (index % 3 == 0)
              ? 280.0
              : (index % 2 == 0)
              ? 220.0
              : 320.0;

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Shimmer.fromColors(
            baseColor: isDark
                ? AppColors.darkShimmerBase
                : AppColors.shimmerBase,
            highlightColor: isDark
                ? AppColors.darkShimmerHighlight
                : AppColors.shimmerHighlight,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
