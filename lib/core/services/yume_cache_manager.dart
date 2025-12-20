import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Custom cache manager with retry logic for handling 524 timeouts
/// and other transient network errors from Pollinations.ai
class YumeCacheManager extends CacheManager {
  static const key = 'yumeCache';

  static YumeCacheManager? _instance;

  factory YumeCacheManager() {
    _instance ??= YumeCacheManager._();
    return _instance!;
  }

  YumeCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService:
              HttpFileService(), // Uses default HTTP client with retries
        ),
      );
}
