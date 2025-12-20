import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/utils/result.dart';
import '../data/datasources/pollinations_datasource.dart';
import '../data/repositories/wallpaper_repository_impl.dart';
import '../domain/art_style.dart';
import '../domain/entities/generation_state.dart';
import '../domain/repositories/wallpaper_repository.dart';

part 'create_providers.g.dart';

// =============================================================================
// DEPENDENCY INJECTION
// =============================================================================

/// Provides Dio HTTP client
@riverpod
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}

/// Provides PollinationsDataSource
@riverpod
PollinationsDataSource pollinationsDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PollinationsDataSource(dio: dio);
}

/// Provides WallpaperRepository
@riverpod
WallpaperRepository wallpaperRepository(Ref ref) {
  final dataSource = ref.watch(pollinationsDataSourceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return WallpaperRepositoryImpl(
    dataSource: dataSource,
    storageService: storageService,
  );
}

// =============================================================================
// UI STATE PROVIDERS
// =============================================================================

/// Provider for the user's prompt text
@riverpod
class PromptText extends _$PromptText {
  @override
  String build() => '';

  void update(String text) {
    state = text;
  }

  void clear() {
    state = '';
  }
}

/// Provider for the selected art style
@riverpod
class SelectedStyle extends _$SelectedStyle {
  @override
  ArtStyle? build() => null;

  void select(ArtStyle style) {
    state = style;
  }

  void clear() {
    state = null;
  }
}

// =============================================================================
// CREATE CONTROLLER
// =============================================================================

/// Main controller for the Create feature
/// Manages generation state: Initial, Loading, Success, Error
@riverpod
class CreateController extends _$CreateController {
  @override
  GenerationState build() => const GenerationInitial();

  /// Generates a wallpaper using the provided prompt and style
  Future<void> generateWallpaper({
    required String prompt,
    required String style,
  }) async {
    // Set loading state
    state = const GenerationLoading();

    // Get repository
    final repository = ref.read(wallpaperRepositoryProvider);

    // Generate wallpaper
    final result = await repository.generateWallpaper(
      prompt: prompt,
      style: style,
    );

    // Minimum delay to show loading state (better UX)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Update state based on result
    // UI will handle navigation via ref.listen
    result.when(
      success: (imageUrl) {
        state = GenerationSuccess(imageUrl);
      },
      failure: (message) {
        state = GenerationError(message);
      },
    );
  }

  /// Resets the controller to initial state
  void reset() {
    state = const GenerationInitial();
  }
}
