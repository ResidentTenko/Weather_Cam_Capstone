// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_capstone_weather/models/city_model.dart';
import 'package:my_capstone_weather/models/custom_error.dart';
import 'package:my_capstone_weather/services/weather_api_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState.initial()) {
    on<FetchCityListEvent>(_fetchCities);
  }
  Future<void> _fetchCities(
    FetchCityListEvent event,
    Emitter<SearchState> emit,
  ) async {
    // emit the next state when the function is called
    emit(
      state.copyWith(status: SearchStatus.loading),
    );
    // try to load the city list
    try {
      print("City List State Before Emit: $state");
      // get a weather API services instance
      final WeatherApiServices weatherApiServices = WeatherApiServices();
      // use that to get the weather information
      final List<City> cities =
          await weatherApiServices.getCities(event.cityQuery);
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          status: SearchStatus.loaded,
          cities: cities,
        ),
      );
      print("Weather State After Emit: $state");
    } on CustomError catch (e) {
      emit(state.copyWith(status: SearchStatus.error, error: e));
    }
  }
}
