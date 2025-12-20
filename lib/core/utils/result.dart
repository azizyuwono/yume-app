/// Result type for handling success and failure cases
sealed class Result<T> {
  const Result();
}

/// Success result with data
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Failure result with error message
final class Failure<T> extends Result<T> {
  const Failure(this.message, [this.exception]);
  final String message;
  final Exception? exception;
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Gets the data if success, otherwise returns null
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Gets the error message if failure, otherwise returns null
  String? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final message) => message,
  };

  /// Maps the result to another type
  Result<R> map<R>(R Function(T data) mapper) => switch (this) {
    Success(:final data) => Success(mapper(data)),
    Failure(:final message, :final exception) => Failure(message, exception),
  };

  /// Handles both success and failure cases
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) => switch (this) {
    Success(:final data) => success(data),
    Failure(:final message) => failure(message),
  };
}
