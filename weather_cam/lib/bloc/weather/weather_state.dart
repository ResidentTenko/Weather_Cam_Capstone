// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

// we make error dynamic to handle different types of exceptions
class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final GenericError error;

  const WeatherState({
    required this.status,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
      error: const GenericError(message: "No Errors"),
    );
  }

  @override
  List<Object> get props => [
        status,
        weather,
        error,
      ];

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, error: $error)';

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    GenericError? error,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }
}
