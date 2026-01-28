import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yume_app/core/services/storage_service.dart';
import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/create/data/datasources/pollinations_datasource.dart';
import 'package:yume_app/features/create/data/repositories/wallpaper_repository_impl.dart';

import 'wallpaper_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PollinationsDataSource>(),
  MockSpec<StorageService>(),
])
void main() {
  late WallpaperRepositoryImpl repository;
  late MockPollinationsDataSource mockDataSource;
  late MockStorageService mockStorageService;

  setUp(() {
    provideDummy<Result<String>>(const Failure(''));
    provideDummy<Result<void>>(const Success(null));
    mockDataSource = MockPollinationsDataSource();
    mockStorageService = MockStorageService();
    repository = WallpaperRepositoryImpl(
      dataSource: mockDataSource,
      storageService: mockStorageService,
    );
  });

  group('WallpaperRepositoryImpl', () {
    const tPrompt = 'A beautiful sunset';
    const tStyle = 'cyberpunk';
    const tImageUrl = 'https://example.com/image.jpg';

    test(
        'should return Success<String> and save wallpaper when generation is successful',
        () async {
      // Arrange
      when(
        mockDataSource.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).thenAnswer((_) async => const Success(tImageUrl));

      when(mockStorageService.saveWallpaper(any)).thenAnswer(
        (_) async => const Success(null),
      );

      // Act
      final result = await repository.generateWallpaper(
        prompt: tPrompt,
        style: tStyle,
      );

      // Assert
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, tImageUrl);
      verify(
        mockDataSource.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).called(1);
      verify(mockStorageService.saveWallpaper(any)).called(1);
    });

    test('should return Failure when generation fails', () async {
      // Arrange
      const tError = 'Network error';
      when(
        mockDataSource.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).thenAnswer((_) async => const Failure(tError));

      // Act
      final result = await repository.generateWallpaper(
        prompt: tPrompt,
        style: tStyle,
      );

      // Assert
      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).message, tError);
      verify(
        mockDataSource.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).called(1);
      verifyNever(mockStorageService.saveWallpaper(any));
    });
  });
}
