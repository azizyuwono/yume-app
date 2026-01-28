import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/home/domain/wallpaper.dart';

/// Repository for Home screen data
abstract class HomeRepository {
  /// Get user's generated wallpapers from local storage
  Future<Result<List<Wallpaper>>> getWallpapers();

  /// Get featured/curated wallpapers for inspiration
  Future<Result<List<Wallpaper>>> getFeaturedWallpapers();

  /// Delete a wallpaper by ID
  Future<Result<void>> deleteWallpaper(String id);
}
