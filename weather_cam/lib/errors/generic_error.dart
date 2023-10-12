class GenericError implements Exception {
  final dynamic message;
  const GenericError({
    required this.message,
  });

  @override
  String toString() => 'GenericError(message: $message)';
}
