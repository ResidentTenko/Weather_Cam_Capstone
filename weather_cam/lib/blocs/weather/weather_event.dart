part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeatherFromLocationEvent extends WeatherEvent {}


// there is only one event releated to weather - get the weather information
// this event is triggered the moment the state receives a query
// this means when the app starts up and provides location data and when the user selects a city of choice
class FetchWeatherEvent extends WeatherEvent {
  final String inputQuery;

  const FetchWeatherEvent({
    required this.inputQuery,
  });
}
