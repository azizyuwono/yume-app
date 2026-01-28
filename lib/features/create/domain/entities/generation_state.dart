/// Generation state for the Create feature
sealed class GenerationState {
  const GenerationState();
}

/// Initial state - ready for input
final class GenerationInitial extends GenerationState {
  const GenerationInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerationInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Loading state - generating wallpaper
final class GenerationLoading extends GenerationState {
  const GenerationLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerationLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Success state - wallpaper generated
final class GenerationSuccess extends GenerationState {
  const GenerationSuccess(this.imageUrl);
  final String imageUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerationSuccess &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => imageUrl.hashCode;
}

/// Error state - generation failed
final class GenerationError extends GenerationState {
  const GenerationError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerationError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
