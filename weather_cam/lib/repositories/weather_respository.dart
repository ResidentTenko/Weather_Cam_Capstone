// ignore_for_file: public_member_api_docs, sort_constructors_first, library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/models/weather.dart';
import 'package:flutter_application/services/api_weather_services.dart';


class ApiWeatherRepository {
  final ApiWeatherServices apiWeatherServices;
  final fbAuth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  // constructor
  ApiWeatherRepository({
    required this.apiWeatherServices,
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  
  // takes a string and returns a weather type object wrapped in a future
  Future<Weather> setWeather(String query) async {
    try {
      // create and set our weather object
      final weather = await apiWeatherServices.getWeatherFromApi(query: query);

      // get the user ID from the database
      final String dbUserID = firebaseAuth.currentUser!.uid;
      // add the weather object to the database
      apiWeatherServices.addWeatherToDatabase(
        weather: weather,
        forecast: weather.forecast,
        hourly: weather.hourly,
        dbUserID: dbUserID,
      );

      // return weather
      return weather;
    } catch (e) {
      // catch all exceptions (those written in the try block and those not accounted for)
      // we will convert all errors to a generic error
      throw GenericError(message: e);
    }
  }

  // uses the user ID which ties the user and weather documents together to get the stored weather information
  Future<Weather> setWeatherFromDB() async {
    try {
      // get the user ID from the database
      final String dbUserID = firebaseAuth.currentUser!.uid;
      // add the weather object to the database
      final weather = await apiWeatherServices.getWeatherFromFBDatabase(
        dbUserID: dbUserID,
      );
      return weather;
    } catch (e) {
      throw GenericError(message: e);
    }
  }
}
