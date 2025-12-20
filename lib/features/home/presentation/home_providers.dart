import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/utils/result.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/wallpaper.dart';

part 'home_providers.g.dart';

// =============================================================================
// REPOSITORIES
// =============================================================================

@riverpod
HomeRepository homeRepository(Ref ref) {
  final storageService = ref.watch(storageServiceProvider);
  return HomeRepositoryImpl(storageService: storageService);
}

// =============================================================================
// DATA PROVIDERS
// =============================================================================

/// Stream of user-generated wallpapers (for History screen)
/// Stream of user-generated wallpapers (for History screen)
@riverpod
Stream<List<Wallpaper>> allWallpapers(Ref ref) async* {
  final repository = ref.watch(homeRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);

  // Initial data
  final initialResult = await repository.getWallpapers();
  yield initialResult.when(success: (data) => data, failure: (_) => []);

  // Watch for changes
  await for (final _ in storageService.watch()) {
    final result = await repository.getWallpapers();
    yield result.when(success: (data) => data, failure: (_) => []);
  }
}

/// Featured/curated wallpapers for Home screen inspiration
/// Shuffles on each refresh for variety
@riverpod
Future<List<Wallpaper>> featuredWallpapers(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getFeaturedWallpapers();
  return result.when(
    success: (data) {
      // Shuffle for variety on each refresh
      final shuffled = [...data]..shuffle();
      return shuffled;
    },
    failure: (_) => [],
  );
}

// =============================================================================
// UI STATE PROVIDERS
// =============================================================================

/// Provider for the currently selected category filter
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  WallpaperCategory build() => WallpaperCategory.all;

  void select(WallpaperCategory category) {
    state = category;
  }
}

/// Provider for filtered wallpapers based on selected category
/// Used by HOME SCREEN (shows featured content)
@riverpod
class FilteredWallpapers extends _$FilteredWallpapers {
  @override
  Future<List<Wallpaper>> build() async {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    // Await the future provider
    final featured = await ref.watch(featuredWallpapersProvider.future);

    // Show all if "All" category selected
    if (selectedCategory == WallpaperCategory.all) {
      return featured;
    }

    // Filter by selected category
    return featured
        .where((wallpaper) => wallpaper.category == selectedCategory)
        .toList();
  }
}
