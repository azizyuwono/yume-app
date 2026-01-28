import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yume_app/core/utils/result.dart';

/// DataSource for generating AI wallpapers via Pollinations.ai API
/// Optimized for mobile phone wallpapers with robust error handling
class PollinationsDataSource {
  PollinationsDataSource({required this.dio});

  final Dio dio;

  static const String _baseUrl = 'https://image.pollinations.ai/prompt/';

  // HD Resolution for crisp mobile display (9:16 aspect ratio)
  static const int _width = 1080;
  static const int _height = 1920;
  static const String _model = 'flux';
  static const bool _enhance = false;

  // Retry configuration for reliability
  static const int _maxRetries = 5;
  static const Duration _baseTimeout = Duration(seconds: 90);

  /// Generates a wallpaper from the given prompt and style
  /// Returns Success with image URL, or Failure with user-friendly error message
  Future<Result<String>> generateWallpaper({
    required String prompt,
    required String style,
  }) async {
    try {
      // 1. Construct enhanced prompt for better quality
      final enhancedPrompt =
          '$prompt, $style style, ultra high quality, '
          'detailed, sharp, phone wallpaper, 8k, professional, masterpiece';
      final encodedPrompt = Uri.encodeComponent(enhancedPrompt);
      final seed = Random().nextInt(1000000);

      final imageUrl =
          '$_baseUrl$encodedPrompt'
          '?width=$_width'
          '&height=$_height'
          '&model=$_model'
          '&nologo=true'
          '&enhance=$_enhance'
          '&seed=$seed';

      // 2. ROBUST RETRY LOGIC WITH EXPONENTIAL BACKOFF
      // Handles: 429 (rate limit), 502 (bad gateway), 524 (timeout)
      int retryCount = 0;

      while (retryCount <= _maxRetries) {
        try {
          // Warm up the image generation (triggers server-side processing)
          final response = await dio.get(
            imageUrl,
            options: Options(
              responseType: ResponseType.bytes,
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: _baseTimeout,
              // Accept all status codes to handle errors gracefully
              validateStatus: (status) => true,
            ),
          );

          final statusCode = response.statusCode ?? 0;

          // SUCCESS: Image generated
          if (statusCode >= 200 && statusCode < 300) {
            return Success(imageUrl);
          }

          // RATE LIMIT (429): Wait longer before retry
          if (statusCode == 429) {
            retryCount++;
            if (retryCount > _maxRetries) {
              return const Failure(
                'AI server is very busy right now.\n'
                'Please wait 30 seconds and try again.',
              );
            }
            // Longer wait for rate limit: 5s, 10s, 20s, 40s, 60s
            final waitSeconds = 5 * (1 << (retryCount - 1));
            await Future.delayed(Duration(seconds: waitSeconds.clamp(5, 60)));
            continue;
          }

          // BAD GATEWAY (502) or SERVER ERROR (5xx): Retry with backoff
          if (statusCode >= 500) {
            retryCount++;

            if (retryCount > _maxRetries) {
              return const Failure(
                'AI server is temporarily unavailable.\n'
                'Please try again in a few minutes.',
              );
            }

            // Exponential backoff: 2s, 4s, 8s, 16s, 32s
            final waitSeconds = 2 * (1 << (retryCount - 1));
            await Future.delayed(Duration(seconds: waitSeconds.clamp(2, 32)));
            continue;
          }

          // CLIENT ERROR (4xx except 429): Don't retry
          if (statusCode >= 400 && statusCode < 500) {
            return Failure(
              'Invalid request (Error $statusCode).\n'
              'Try simplifying your prompt.',
            );
          }

          // Unknown status - retry once
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
        } on DioException catch (e) {
          retryCount++;

          final isTimeout =
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout;

          final isConnectionError = e.type == DioExceptionType.connectionError;

          // NO INTERNET: Don't retry
          if (isConnectionError) {
            return const Failure(
              'No internet connection.\n'
              'Please check your network and try again.',
            );
          }

          // TIMEOUT: Retry with backoff
          if (isTimeout && retryCount <= _maxRetries) {
            final waitSeconds = 3 * retryCount;
            await Future.delayed(Duration(seconds: waitSeconds));
            continue;
          }

          // Max retries reached for timeout
          if (isTimeout) {
            return const Failure(
              'Generation is taking too long.\n'
              'Try a shorter or simpler prompt, or wait and retry.',
            );
          }

          // Other errors: Retry up to max
          if (retryCount <= _maxRetries) {
            await Future.delayed(Duration(seconds: 2 * retryCount));
            continue;
          }

          return const Failure(
            'Network error occurred.\n'
            'Please check your connection and try again.',
          );
        }
      }

      // Should never reach here
      return const Failure(
        'Failed after multiple attempts.\n'
        'Please try again later.',
      );
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }
}
