part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable{
  const LocationEvent();

  @override
  List<Object> get props => [];
}
// there is only one event related to location - Fetch the current location
// we don't need to take in a payload to FetchLocationEvent is left empty
class FetchLocationEvent extends LocationEvent{}

