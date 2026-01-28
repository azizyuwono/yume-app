import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yume_app/core/utils/result.dart';
import 'package:yume_app/features/create/domain/entities/generation_state.dart';
import 'package:yume_app/features/create/domain/repositories/wallpaper_repository.dart';
import 'package:yume_app/features/create/presentation/create_providers.dart';

import 'create_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WallpaperRepository>()])
void main() {
  late ProviderContainer container;
  late MockWallpaperRepository mockRepository;

  setUp(() {
    provideDummy<Result<String>>(const Failure(''));
    provideDummy<Result<void>>(const Success(null));
    mockRepository = MockWallpaperRepository();
    container = ProviderContainer(
      overrides: [
        wallpaperRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    // Keep the provider alive
    container.listen(createControllerProvider, (previous, next) {});
  });

  tearDown(() {
    container.dispose();
  });

  group('CreateController', () {
    const tPrompt = 'A beautiful sunset';
    const tStyle = 'cyberpunk';
    const tImageUrl = 'https://example.com/image.jpg';

    test('initial state is GenerationInitial', () {
      final state = container.read(createControllerProvider);
      expect(state, const GenerationInitial());
    });

    test(
        'generateWallpaper emits [GenerationLoading, GenerationSuccess] on success',
        () async {
      // Arrange
      when(
        mockRepository.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).thenAnswer((_) async => const Success(tImageUrl));

      // Act
      final future = container
          .read(createControllerProvider.notifier)
          .generateWallpaper(prompt: tPrompt, style: tStyle);

      // Assert initial state
      expect(
        container.read(createControllerProvider),
        const GenerationLoading(),
      );

      await future;

      // Assert final state
      expect(
        container.read(createControllerProvider),
        const GenerationSuccess(tImageUrl),
      );

      verify(
        mockRepository.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).called(1);
    });

    test(
        'generateWallpaper emits [GenerationLoading, GenerationError] on failure',
        () async {
      // Arrange
      const tError = 'Network error';
      when(
        mockRepository.generateWallpaper(prompt: tPrompt, style: tStyle),
      ).thenAnswer((_) async => const Failure(tError));

      // Act
      final future = container
          .read(createControllerProvider.notifier)
          .generateWallpaper(prompt: tPrompt, style: tStyle);

      // Assert initial state
      expect(
        container.read(createControllerProvider),
        const GenerationLoading(),
      );

      await future;

      // Assert final state
      expect(
        container.read(createControllerProvider),
        const GenerationError(tError),
      );
    });

    test('reset sets state to GenerationInitial', () {
      // Arrange
      container.read(createControllerProvider.notifier).reset();

      // Assert
      expect(
        container.read(createControllerProvider),
        const GenerationInitial(),
      );
    });
  });
}
