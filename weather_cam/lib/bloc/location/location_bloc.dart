// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_capstone_weather/models/custom_error.dart';
import 'package:my_capstone_weather/services/location_services.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState.initial()) {
    on<FetchLocationEvent>(_fetchPosition);
  }
  Future<void> _fetchPosition(
    FetchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    // print the current state
    print("Location State Before Emit: $state");
    // change the state to loading before the try
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      // get the location
      final LocationServices locationServices = LocationServices();
      Position position = await locationServices.getCurrentPosition();

      // load and emit the location
      emit(
        state.copyWith(
          status: LocationStatus.loaded,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      // print the current state
      print("Location State After Emit: $state");
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: LocationStatus.error,
          error: e,
        ),
      );
    }
  }
}
