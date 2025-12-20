import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../../home/domain/wallpaper.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../datasources/pollinations_datasource.dart';

/// Implementation of WallpaperRepository using Pollinations.ai
class WallpaperRepositoryImpl implements WallpaperRepository {
  const WallpaperRepositoryImpl({
    required this.dataSource,
    required this.storageService,
  });

  final PollinationsDataSource dataSource;
  final StorageService storageService;

  @override
  Future<Result<String>> generateWallpaper({
    required String prompt,
    required String style,
  }) async {
    final result = await dataSource.generateWallpaper(
      prompt: prompt,
      style: style,
    );

    // If successful, save to local storage
    if (result is Success<String>) {
      final imageUrl = result.data;
      // Create a Wallpaper object
      final wallpaper = Wallpaper(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imageUrl,
        prompt: prompt,
        category: WallpaperCategory.all, // Default category
      );

      // Save to storage (fire and forget)
      await storageService.saveWallpaper(wallpaper);
    }

    return result;
  }
}
