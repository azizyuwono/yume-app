import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

import '../utils/result.dart';

part 'wallpaper_service.g.dart';

/// Location options for setting wallpaper
enum WallpaperLocation { homeScreen, lockScreen, both }

/// Provider for WallpaperService
@riverpod
WallpaperService wallpaperService(Ref ref) => WallpaperService();

/// Service for setting device wallpaper
/// Note: This feature is Android-only. iOS does not support programmatic wallpaper setting.
class WallpaperService {
  final _cacheManager = DefaultCacheManager();

  /// Check if wallpaper setting is supported on this platform
  bool get isSupported => Platform.isAndroid;

  /// Set wallpaper from URL
  /// Downloads the image first then sets it as wallpaper
  /// Returns [Success] on success, [Failure] on error
  Future<Result<void>> setWallpaperFromUrl(
    String imageUrl,
    WallpaperLocation location,
  ) async {
    if (!isSupported) {
      return const Failure('Setting wallpaper is only supported on Android');
    }

    try {
      // Download image to cache
      final file = await _cacheManager.getSingleFile(imageUrl);

      final locationValue = switch (location) {
        WallpaperLocation.homeScreen => WallpaperManagerPlus.homeScreen,
        WallpaperLocation.lockScreen => WallpaperManagerPlus.lockScreen,
        WallpaperLocation.both => WallpaperManagerPlus.bothScreens,
      };

      // Set wallpaper from cached file
      await WallpaperManagerPlus().setWallpaper(file, locationValue);

      return const Success(null);
    } on PlatformException catch (e) {
      return Failure('Platform error: ${e.message}');
    } catch (e) {
      return Failure('Error setting wallpaper: $e');
    }
  }

  /// Get human-readable label for wallpaper location
  String getLocationLabel(WallpaperLocation location) {
    return switch (location) {
      WallpaperLocation.homeScreen => 'Home Screen',
      WallpaperLocation.lockScreen => 'Lock Screen',
      WallpaperLocation.both => 'Both Screens',
    };
  }
}
