class WeatherApiException implements Exception {
  final String message;

  WeatherApiException({required this.message});

  @override
  String toString() => message;
}
