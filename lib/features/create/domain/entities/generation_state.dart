/// Generation state for the Create feature
sealed class GenerationState {
  const GenerationState();
}

/// Initial state - ready for input
final class GenerationInitial extends GenerationState {
  const GenerationInitial();
}

/// Loading state - generating wallpaper
final class GenerationLoading extends GenerationState {
  const GenerationLoading();
}

/// Success state - wallpaper generated
final class GenerationSuccess extends GenerationState {
  const GenerationSuccess(this.imageUrl);
  final String imageUrl;
}

/// Error state - generation failed
final class GenerationError extends GenerationState {
  const GenerationError(this.message);
  final String message;
}
