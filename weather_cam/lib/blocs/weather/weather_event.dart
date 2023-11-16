part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

// we call this when we want to fetch weather by latitude and longitude
class FetchWeatherFromLocationEvent extends WeatherEvent {}

// we call this when we want to fetch weather from the database
class FetchWeatherFromFBDatabaseEvent extends WeatherEvent {}

// we call this when we want to refresh the weather information after loading from storage
// which occurs on app start
class FetchWeatherOnAppStartEvent extends WeatherEvent {}

// we call this function when the user refreshes the screen
// we also call this when the app comes from the background to the foreground
class FetchWeatherOnAppRefreshEvent extends WeatherEvent {}

// there is only one event releated to weather - get the weather information
class FetchWeatherEvent extends WeatherEvent {
  final String inputQuery;

  const FetchWeatherEvent({
    required this.inputQuery,
  });
}
