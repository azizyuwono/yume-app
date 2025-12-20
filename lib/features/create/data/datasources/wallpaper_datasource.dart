import 'dart:math';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/result.dart';

/// Mock data source that simulates API calls for development
class MockWallpaperDataSource {
  final _random = Random();

  /// Keyword-based Unsplash images for realistic simulation
  static const Map<String, List<String>> _styleImages = {
    'ukiyoe': [
      'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d?w=1080&h=1920&fit=crop',
    ],
    'cyberpunk': [
      'https://images.unsplash.com/photo-1480796927426-f609979314bd?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1515859005217-8a1f08870f59?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1080&h=1920&fit=crop',
    ],
    'nature': [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1518173946687-a4c036bc9c65?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1507400492013-162706c8c05e?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1080&h=1920&fit=crop',
    ],
    'abstract': [
      'https://images.unsplash.com/photo-1549490349-8643362247b5?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1557672172-298e090bd0f1?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1618005198919-d3d4b5a92ead?w=1080&h=1920&fit=crop',
    ],
    'minimal': [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=1080&h=1920&fit=crop',
    ],
    'dreamy': [
      'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1080&h=1920&fit=crop',
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1080&h=1920&fit=crop',
    ],
  };

  /// Simulates generating a wallpaper with network delay
  Future<Result<String>> generateWallpaper({
    required String prompt,
    required String style,
  }) async {
    try {
      // Simulate network delay
      await Future<void>.delayed(
        Duration(milliseconds: AppConstants.mockDelayMs),
      );

      // Get images for the style, fallback to nature if not found
      final images =
          _styleImages[style.toLowerCase()] ?? _styleImages['nature']!;

      // Return random image from the style category
      final imageUrl = images[_random.nextInt(images.length)];

      return Success(imageUrl);
    } on Exception catch (e) {
      return Failure('Failed to generate wallpaper', e);
    }
  }
}

// =============================================================================
// REPLICATE API DATA SOURCE (Prepared for future implementation)
// =============================================================================
//
// import 'package:dio/dio.dart';
//
// class ReplicateApiDataSource {
//   ReplicateApiDataSource({required this.dio, required this.apiKey});
//
//   final Dio dio;
//   final String apiKey;
//
//   static const String _baseUrl = 'https://api.replicate.com/v1';
//   static const String _modelVersion = 'stable-diffusion-xl';
//
//   Future<Result<String>> generateWallpaper({
//     required String prompt,
//     required String style,
//   }) async {
//     try {
//       // Create prediction
//       final response = await dio.post(
//         '$_baseUrl/predictions',
//         options: Options(
//           headers: {
//             'Authorization': 'Token $apiKey',
//             'Content-Type': 'application/json',
//           },
//         ),
//         data: {
//           'version': _modelVersion,
//           'input': {
//             'prompt': '$prompt, $style style, 4k, high quality, phone wallpaper',
//             'width': 1080,
//             'height': 1920,
//           },
//         },
//       );
//
//       if (response.statusCode == 201) {
//         final predictionId = response.data['id'] as String;
//         return _pollForResult(predictionId);
//       }
//
//       return Failure('Failed to start generation: ${response.statusCode}');
//     } on DioException catch (e) {
//       return Failure('Network error: ${e.message}', e);
//     } catch (e) {
//       return Failure('Unknown error: $e');
//     }
//   }
//
//   Future<Result<String>> _pollForResult(String predictionId) async {
//     const maxAttempts = 60;
//     const pollInterval = Duration(seconds: 2);
//
//     for (var i = 0; i < maxAttempts; i++) {
//       await Future.delayed(pollInterval);
//
//       final response = await dio.get(
//         '$_baseUrl/predictions/$predictionId',
//         options: Options(
//           headers: {'Authorization': 'Token $apiKey'},
//         ),
//       );
//
//       final status = response.data['status'] as String;
//
//       if (status == 'succeeded') {
//         final output = response.data['output'] as List?;
//         if (output != null && output.isNotEmpty) {
//           return Success(output.first as String);
//         }
//         return Failure('No output generated');
//       }
//
//       if (status == 'failed' || status == 'canceled') {
//         return Failure('Generation $status');
//       }
//     }
//
//     return Failure('Generation timed out');
//   }
// }
