// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/models/city_model.dart';
import 'package:flutter_application/services/api_weather_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiWeatherServices apiWeatherServices;
  SearchBloc({
    required this.apiWeatherServices,
  }) : super(SearchState.initial()) {
    on<FetchCityListEvent>(_fetchCities);
    on<ResetSearchListEvent>(_resetSearch);
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
      final List<City> cities =
          await apiWeatherServices.getCitiesFromAPi(event.cityQuery);
      // load the weather into the state and emit it
      emit(
        state.copyWith(
          status: SearchStatus.loaded,
          cities: cities,
        ),
      );
      print("City List State After Emit: $state");
    }
    // handle our exceptions and errors
    on GenericError catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _resetSearch(
    ResetSearchListEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchState.initial());
  }
}
