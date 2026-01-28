import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/core/widgets/permission_dialog.dart';

part 'image_download_service.g.dart';

/// Provider for ImageDownloadService
@riverpod
ImageDownloadService imageDownloadService(Ref ref) {
  return ImageDownloadService();
}

/// Service for downloading and saving images to gallery
/// Uses DefaultCacheManager to retrieve images from cache (no network requests)
class ImageDownloadService {
  ImageDownloadService();

  /// Requests storage permission with user consent dialog
  Future<bool> requestStoragePermission(BuildContext context) async {
    // Check if already granted
    final hasAccess = await Gal.hasAccess();
    if (hasAccess) {
      return true;
    }

    // Check if context is still valid before showing dialog
    if (!context.mounted) {
      return false;
    }

    // Show permission dialog to inform user
    final userConsent = await PermissionDialog.show(
      context: context,
      title: 'Storage Permission',
      message:
          'We need access to your gallery to save wallpapers. Your privacy is important to us.',
      icon: Icons.photo_library_rounded,
    );

    if (!userConsent) {
      return false;
    }

    // Request permission
    return Gal.requestAccess();
  }

  /// Downloads an image from URL and saves it to the gallery
  ///
  /// STRATEGY:
  /// 1. Check cache first (instant if available)
  /// 2. If not in cache, wait for it to be cached by CachedNetworkImage
  /// 3. Fallback: Return error if image not available
  ///
  /// This prevents 429 rate limit errors by never making direct HTTP requests
  ///
  /// Returns [Success] with success message, [Failure] with error message on failure
  Future<Result<String>> downloadAndSaveToGallery(
    BuildContext context,
    String imageUrl,
  ) async {
    try {
      // Request permission with user dialog
      final hasPermission = await requestStoragePermission(context);
      if (!hasPermission) {
        return const Failure('Permission denied');
      }

      // CRITICAL: Check cache FIRST (no network request)
      final cacheManager = DefaultCacheManager();
      var fileInfo = await cacheManager.getFileFromCache(imageUrl);

      // If not in cache, wait a bit for CachedNetworkImage to finish loading
      if (fileInfo == null) {
        // Wait up to 2 seconds for cache to populate
        for (var i = 0; i < 4; i++) {
          await Future.delayed(const Duration(milliseconds: 500));
          fileInfo = await cacheManager.getFileFromCache(imageUrl);
          if (fileInfo != null) {
            break;
          }
        }
      }

      // If still not in cache, return helpful error
      if (fileInfo == null) {
        return const Failure(
          'Image not ready yet. Please wait for the preview to fully load before downloading.',
        );
      }

      // Read bytes from cached file
      final bytes = await fileInfo.file.readAsBytes();

      // Save to gallery using Gal
      await Gal.putImageBytes(
        bytes,
        name: 'yume_${DateTime.now().millisecondsSinceEpoch}',
      );

      return const Success('Saved to Gallery');
    } on GalException catch (e) {
      return Failure('Gallery Error: ${e.type.message}');
    } on Exception catch (e) {
      // Handle cache errors or file read errors
      return Failure('Error: $e');
    }
  }
}

extension GalExceptionMessage on GalExceptionType {
  String get message => switch (this) {
    GalExceptionType.accessDenied => 'Access denied',
    GalExceptionType.notEnoughSpace => 'Not enough space',
    GalExceptionType.notSupportedFormat => 'Format not supported',
    GalExceptionType.unexpected => 'Unexpected error',
  };
}
