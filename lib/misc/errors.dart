abstract class AppError {
  const AppError();

  String get description;

  @override
  String toString() {
    return 'Error: $description';
  }
}

class SimpleError extends AppError {
  const SimpleError(this.description);

  @override
  final String description;
}

class ApiError extends AppError {
  const ApiError({
    required this.statusCode,
    this.statusMessage,
    required this.description,
    this.reason,
  });

  final int statusCode;
  final String? statusMessage;
  @override
  final String description;
  final String? reason;

  @override
  String toString() => reason?.isEmpty ?? true
      ? 'Error: $description'
      : 'Error: $description ($reason)';
}

class CancelRequestError extends AppError {
  @override
  String get description => 'Operation cancelled';
}
