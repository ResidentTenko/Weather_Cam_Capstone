// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print
import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/models/weather.dart';
import 'package:flutter_application/repositories/weather_respository.dart';
import 'package:flutter_application/services/location_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> with HydratedMixin {
  // weatherbloc needs to call the weather repository API whenever a fetch weather event occurs
  final ApiWeatherRepository apiWeatherRepository;
  // weatherbloc needs an instance of LocationServices
  final LocationServices locationServices;
  // we will provide our instances through the constructor
  WeatherBloc({
    required this.apiWeatherRepository,
    required this.locationServices,
  }) : super(
          WeatherState.initial(),
        ) {
    on<FetchWeatherEvent>(_fetchWeather);
    on<FetchWeatherFromLocationEvent>(_fetchWeatherByLocation);
    on<FetchWeatherFromFBDatabaseEvent>(_fetchWeatherFromFBDatabase);
    on<FetchWeatherAfterLocalStorageRetrievalEvent>(
        _fetchWeatherAfterLocalStorageRetrieval);
  }

  // function implementations
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

  Future<void> _fetchWeatherByLocation(
    FetchWeatherFromLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // the next state after initial should be loading
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    // try to load the weather information
    try {
      print("Weather State Before Emit: $state");
      // get the last known position (or current position if null)
      final Position position = await locationServices.getLastKnownPosition();
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

  Future<void> _fetchWeatherFromFBDatabase(
    FetchWeatherFromFBDatabaseEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // the next state after initial should be loading
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    // try to load the weather information
    try {
      print("Weather State Before Emit: $state");
      final Weather weather = await apiWeatherRepository.setWeatherFromDB();
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

  Future<void> _fetchWeatherAfterLocalStorageRetrieval(
    FetchWeatherAfterLocalStorageRetrievalEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // the status from the storage should be loaded
    // ** Do not emit loading or you're going to get the circular progress indicator **
    try {
      // get the current position
      final Position position = await locationServices.getCurrentPosition();
      final Weather weather = await apiWeatherRepository
          .setWeather('${position.latitude}, ${position.longitude}');
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          weather: weather,
        ),
      );
      print("Weather State After Retrieval Opeartion: $state");
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

  // The fromJson method is responsible for converting the serialized JSON data, which represents the saved state, back into a usable state object.
  // It takes a json object from storage and returns a state
  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      print('Weather from storage: $json');
      // uses the fromJson method of WeatherState class
      final weatherState = WeatherState.fromJson(json);
      print('WeatherState after Json to State Conversion: $weatherState');
      // returns the state
      return weatherState;
    } catch (e) {
      return null;
    }
  }

  // The toJson method is responsible for converting the current state object into a JSON representation that can be easily stored in persistent storage
  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state.status == WeatherStatus.loaded) {
      print('Weather state to storage: $state');
      // uses the toJson method of WeatherState class
      final weatherJson = state.toJson();
      print('WeatherJson after State to Json Conversion: $weatherJson');
      // returns the json
      return weatherJson;
    } else {
      return null;
    }
  }
}
