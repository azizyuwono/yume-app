import 'package:yume_app/core/services/storage_service.dart';
import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/create/data/datasources/pollinations_datasource.dart';
import 'package:yume_app/features/create/domain/repositories/wallpaper_repository.dart';
import 'package:yume_app/features/home/domain/wallpaper.dart';

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
