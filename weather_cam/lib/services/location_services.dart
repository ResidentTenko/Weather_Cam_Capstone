import 'package:flutter_application/errors/generic_error.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  // implements the get location function
  // returns a position object wrapped in a future
  Future<Position> getLastKnownPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can

      // get the last known position from the device's cache - if null then get the current position
      Position position = await Geolocator.getLastKnownPosition() ??await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      return position;
    } catch (e) {
      throw GenericError(message: e);
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // get the current position this time
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      return position;
    } catch (e) {
      throw GenericError(message: e);
    }
  }
}
