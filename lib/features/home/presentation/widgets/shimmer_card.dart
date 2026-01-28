import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:yume_app/core/theme/app_colors.dart';

/// Shimmer loading placeholder for wallpaper cards
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.height = 200});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

/// Shimmer loading grid for the gallery
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ShimmerCard(height: 180 + (index % 3) * 40.0);
      },
    );
  }
}
