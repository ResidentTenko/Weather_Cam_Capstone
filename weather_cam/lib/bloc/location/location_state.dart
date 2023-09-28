part of 'location_bloc.dart';

// lists the state of our location status
enum LocationStatus {
  initial,
  loading,
  loaded,
  error,
}

class LocationState extends Equatable {
  final double longitude;
  final double latitude;
  final LocationStatus status;
  final CustomError error;

  const LocationState({
    required this.longitude,
    required this.latitude,
    required this.status,
    required this.error,
  });

  factory LocationState.initial() {
    return const LocationState(
      status: LocationStatus.initial,
      longitude: 0.0,
      latitude: 0.0,
      error: CustomError(),
    );
  }

  @override
  String toString() =>
      'LocationState(status: $status, latitude: $latitude, longitude: $longitude)';



  LocationState copyWith({
    double? longitude,
    double? latitude,
    LocationStatus? status,
    CustomError? error,
  }) {
    return LocationState(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [longitude, latitude, status, error];
}
