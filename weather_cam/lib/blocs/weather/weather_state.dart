// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  // close out the properties of the enum with ';'
  error;

  // returns a string
  // name is the string representation of the enum's value
  // mouse over name for more
  String toJson() => name;

  /// The fromJson method takes a JSON string as input and uses the values.byName method to convert it back into the corresponding WeatherStatus enum value.
  /// So it returns a value of the enum that matches the name of the taken string
  /// If the input string matches one of the enum's names, it returns the corresponding enum value; otherwise, it returns null
  static WeatherStatus fromJson(String json) => values.byName(json);
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

  // Called when converting the state to a map (think of it in terms of JSON)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.toJson(),
      'weather': weather.toJson(),
      'error': error.toJson(),
    };
  }

  // Called when converting the storage JSON back to a state object
  factory WeatherState.fromJson(Map<String, dynamic> json) {
    return WeatherState(
      status: WeatherStatus.fromJson(json['status']),
      weather: Weather.fromStorageJson(json['weather'] as Map<String, dynamic>),
      error: GenericError.fromJson(json['error'] as dynamic),
    );
  }
}
