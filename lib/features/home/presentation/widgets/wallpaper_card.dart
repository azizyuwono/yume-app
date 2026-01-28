import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:yume_app/core/theme/app_colors.dart';
import 'package:yume_app/features/home/domain/wallpaper.dart';

/// Wallpaper card for the masonry grid with optional Hero animation
class WallpaperCard extends StatefulWidget {
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.onTap,
    this.onLongPress,
    this.animationDelay = Duration.zero,
    this.enableHero = true,
  });

  final Wallpaper wallpaper;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration animationDelay;
  final bool enableHero;

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1 / widget.wallpaper.aspectRatio,
        child: CachedNetworkImage(
          imageUrl: widget.wallpaper.imageUrl,
          // Use distinct cache key for thumbnails (so it doesn't conflict with HD Preview)
          cacheKey: '${widget.wallpaper.imageUrl}_thumbnail',
          fit: BoxFit.cover,
          // OPTIMIZATION: Height 640 to match our new reduced resolution
          // Helps prevent OOM on older devices
          memCacheHeight: 640,
          placeholder: (context, url) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Shimmer.fromColors(
              baseColor: isDark
                  ? AppColors.darkShimmerBase
                  : AppColors.shimmerBase,
              highlightColor: isDark
                  ? AppColors.darkShimmerHighlight
                  : AppColors.shimmerHighlight,
              child: Container(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.1,
                    ),
                    size: 32,
                  ),
                ),
              ),
            );
          },
          // FAIL-SAFE UI: Silent Fallback
          // If Pollinations API fails (524 or 429), load a backup image from Picsum.
          // This ensures the grid always looks populated.
          errorWidget: (context, url, error) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final fallbackUrl =
                'https://picsum.photos/360/640?random=${widget.wallpaper.id}';

            return CachedNetworkImage(
              imageUrl: fallbackUrl,
              fit: BoxFit.cover,
              memCacheHeight: 640,
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
              ),
              // If even the backup fails, then show a subtle error icon
              errorWidget: (context, url, error) => Container(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: isDark
                        ? AppColors.darkOnSurface.withValues(alpha: 0.2)
                        : AppColors.grey300,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: widget.enableHero
              ? Hero(
                  tag: 'wallpaper_${widget.wallpaper.id}',
                  child: imageWidget,
                )
              : imageWidget,
        ),
      ),
    );
  }
}
