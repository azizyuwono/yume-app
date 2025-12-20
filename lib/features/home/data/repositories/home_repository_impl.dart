import 'dart:math';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/wallpaper.dart';

/// Implementation of HomeRepository using StorageService
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required this.storageService});

  final StorageService storageService;

  @override
  Future<Result<List<Wallpaper>>> getWallpapers() async {
    try {
      // Get wallpapers from local storage
      final wallpapers = storageService.getAllWallpapers();
      return Success(wallpapers);
    } catch (e) {
      return Failure('Failed to fetch wallpapers: $e');
    }
  }

  @override
  Future<Result<List<Wallpaper>>> getFeaturedWallpapers() async {
    try {
      // Dynamic wallpaper generation with variety
      final random = Random();

      // Theme pool for diverse wallpapers
      const themes = [
        'cyberpunk',
        'vaporwave',
        'minimalist landscape',
        'abstract fluid',
        'futuristic city',
        'zen garden',
        'neon noir',
        'dreamy clouds',
      ];

      // Category mapping for themes
      final categoryMap = {
        'cyberpunk': WallpaperCategory.abstract,
        'vaporwave': WallpaperCategory.abstract,
        'minimalist landscape': WallpaperCategory.nature,
        'abstract fluid': WallpaperCategory.abstract,
        'futuristic city': WallpaperCategory.abstract,
        'zen garden': WallpaperCategory.nature,
        'neon noir': WallpaperCategory.abstract,
        'dreamy clouds': WallpaperCategory.nature,
      };

      // Generate 4 unique wallpapers (reduced from 6 to minimize API load)
      // Each grid row shows 2 wallpapers, so 4 = 2 rows (perfect for initial view)
      final wallpapers = List.generate(4, (index) {
        // Random theme selection
        final theme = themes[random.nextInt(themes.length)];
        // Random seed for variety (0 to 1,000,000)
        final seed = random.nextInt(1000000);
        // Current timestamp for cache busting
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        // Encode theme for URL
        final encodedTheme = Uri.encodeComponent(theme);

        // CRITICAL: Use 'turbo' grid model for fast loading
        // Resolution: 360x640 (Small size to prevent timeouts)
        // turbo model: Much faster than flux, perfect for grid previews
        final imageUrl =
            'https://image.pollinations.ai/prompt/$encodedTheme?width=360&height=640&model=turbo&seed=$seed&nologo=true';

        return Wallpaper(
          id: 'dynamic_${timestamp}_$index',
          imageUrl: imageUrl,
          prompt: theme,
          category: categoryMap[theme] ?? WallpaperCategory.abstract,
        );
      });

      return Success(wallpapers);
    } catch (e) {
      // Fallback to empty list on error
      return Failure('Failed to generate wallpapers: $e');
    }
  }

  @override
  Future<Result<void>> deleteWallpaper(String id) async {
    return await storageService.deleteWallpaper(id);
  }
}
