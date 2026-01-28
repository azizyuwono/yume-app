import 'package:yume_app/core/utils/result.dart';

/// Abstract repository for wallpaper generation
abstract class WallpaperRepository {
  /// Generates a wallpaper based on prompt and style
  ///
  /// [prompt] - User's description of the desired wallpaper
  /// [style] - Art style (e.g., 'ukiyoe', 'cyberpunk', 'nature')
  ///
  /// Returns a [Result] containing the image URL on success,
  /// or an error message on failure.
  Future<Result<String>> generateWallpaper({
    required String prompt,
    required String style,
  });
}
