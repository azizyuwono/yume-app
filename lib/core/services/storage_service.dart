import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/create/data/models/local_wallpaper.dart';
import 'package:yume_app/features/home/domain/wallpaper.dart';

part 'storage_service.g.dart';

/// Provider for StorageService
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  return StorageService();
}

/// Service to handle local storage using Hive
class StorageService {
  static const String _boxName = 'wallpapers';

  /// Initialize Hive and open box
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LocalWallpaperAdapter());
    await Hive.openBox<LocalWallpaper>(_boxName);
  }

  /// Get the open box
  Box<LocalWallpaper> get _box => Hive.box<LocalWallpaper>(_boxName);

  /// Save a wallpaper to local storage
  Future<Result<void>> saveWallpaper(Wallpaper wallpaper) async {
    try {
      final localWallpaper = LocalWallpaper.fromDomain(wallpaper);
      await _box.put(wallpaper.id, localWallpaper);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to save wallpaper: $e');
    }
  }

  /// Get all saved wallpapers
  List<Wallpaper> getAllWallpapers() {
    try {
      if (!_box.isOpen) {
        return [];
      }

      final localWallpapers = _box.values.toList();
      // Sort by newest first (assuming id or insertion order)
      // Since Hive preserves insertion order for values, we reverse it
      return localWallpapers
          .map((e) => e.toDomain())
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Watch for changes in the box
  Stream<BoxEvent> watch() {
    return _box.watch();
  }

  /// Delete a wallpaper
  Future<Result<void>> deleteWallpaper(String id) async {
    try {
      await _box.delete(id);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to delete wallpaper: $e');
    }
  }

  /// Check if wallpaper exists
  bool hasWallpaper(String id) {
    return _box.containsKey(id);
  }
}
