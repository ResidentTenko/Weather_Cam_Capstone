// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_capstone_weather/models/custom_error.dart';
import 'package:my_capstone_weather/models/weather.dart';
import 'package:my_capstone_weather/services/weather_api_services.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherState.initial()) {
    on<FetchWeatherEvent>(_fetchWeather);
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
      // get a weather API services instance
      final WeatherApiServices weatherApiServices = WeatherApiServices();
      // use that to get the weather information
      final Weather weather =
          await weatherApiServices.getWeather(event.inputQuery);
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ),
      );
      print("Weather State After Emit: $state");
    } on CustomError catch (e) {
      emit(state.copyWith(status: WeatherStatus.error, error: e));
    }
  }
}
