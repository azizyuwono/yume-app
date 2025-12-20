import '../../../../core/utils/result.dart';
import '../wallpaper.dart';

/// Repository for Home screen data
abstract class HomeRepository {
  /// Get user's generated wallpapers from local storage
  Future<Result<List<Wallpaper>>> getWallpapers();

  /// Get featured/curated wallpapers for inspiration
  Future<Result<List<Wallpaper>>> getFeaturedWallpapers();

  /// Delete a wallpaper by ID
  Future<Result<void>> deleteWallpaper(String id);
}
