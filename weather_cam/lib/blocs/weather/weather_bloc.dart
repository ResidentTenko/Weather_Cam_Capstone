// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/models/weather.dart';
import 'package:flutter_application/repositories/weather_respository.dart';
import 'package:flutter_application/services/location_services.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // weatherbloc needs to call the weather repository API whenever a fetch weather event occurs
  final ApiWeatherRepository apiWeatherRepository;
  // we will provide an instance of weather repository through the constructor
  WeatherBloc({
    required this.apiWeatherRepository,
  }) : super(WeatherState.initial()) {
    on<FetchWeatherEvent>(_fetchWeather);
    on<FetchWeatherByLocationEvent>(_fetchWeatherByLocation);
  }

  Future<void> _fetchWeatherByLocation(
    FetchWeatherByLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // the next state after initial should be loading
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    // try to load the weather information
    try {
      print("Weather State Before Emit: $state");
      final LocationServices locationServices = LocationServices();
      final Position position = await locationServices.getCurrentPosition();
      final Weather weather = await apiWeatherRepository
          .setWeather('${position.latitude}, ${position.longitude}');
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ),
      );
      print("Weather State After Emit: $state");
      // handle our exceptions and errors
    } on GenericError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ),
      );
    }
  }

  Future<void> _fetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // the next state after initial should be loading
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    // try to load the weather information
    try {
      print("Weather State Before Emit: $state");
      final Weather weather =
          await apiWeatherRepository.setWeather(event.inputQuery);
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ),
      );
      print("Weather State After Emit: $state");
      // handle our exceptions and errors
    } on GenericError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ),
      );
    }
  }
}
