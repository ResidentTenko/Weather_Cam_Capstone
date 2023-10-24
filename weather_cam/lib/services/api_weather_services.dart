// ignore_for_file: library_prefixes

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/constants/db_constant.dart';
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/errors/http_error_status_exception.dart';
import 'package:flutter_application/errors/weather_api_exception.dart';
import 'package:flutter_application/models/city_model.dart';
import 'package:flutter_application/models/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class ApiWeatherServices {
  final http.Client httpClient;
  // constructor
  ApiWeatherServices({required this.httpClient});
  // takes a string and returns a weather type object wrapped in a future
  Future<Weather> getWeatherFromApi({required String query}) async {
    // use a uri object instead of a direct url
    final Uri uri = Uri(
      // we're basically building the url piece by piece
      scheme: 'https',
      host: 'api.weatherapi.com',
      path: '/v1/forecast.json',
      queryParameters: {
        'key': dotenv.env['APPID'],
        'q': query,
        'days': '3',
        'aqi': 'no',
        'alerts': 'no',
      },
    );
    try {
      // retrieve a response body from the uri
      final http.Response response = await httpClient.get(uri);

      // create and throw a http error status exception object
      // we will handle this at a higher level
      if (response.statusCode != 200) {
        throw HttpErrorStatusException(
          responseMessage:
              'HttpErrorStatusException\nStatus Code: ${response.statusCode}\nResponse Message: ${response.reasonPhrase}',
        );
      }
      // else - decode the response
      final responseBody = json.decode(response.body);

      // handle this weather exception at the calling level - bloc level
      if (responseBody.isEmpty) {
        throw WeatherApiException(
            message:
                'WeatherApiException: Cannot get the weather information of: $query');
      }

      // feed the response bodyto our weather object and build a weather object
      final Weather weather = Weather.fromApiJson(responseBody);

      // return our weather object
      return weather;
    } catch (e) {
      // catch all exceptions (those written in the try block and those not accounted for)
      // we will convert all errors to a generic error
      throw GenericError(message: e);
    }
  }

  Future<Weather> getWeatherFromFBDatabase({
    required String dbUserID,
  }) async {
    try {
      final DocumentSnapshot weatherDoc = await weatherRef.doc(dbUserID).get();

      if (weatherDoc.exists) {
        final weather = Weather.fromFBDatabase(weatherDoc);
        return weather;
      }

      throw const GenericError(message: "Weather information does not exist");
    } catch (e) {
      throw GenericError(message: e);
    }
  }

  Future<void> addWeatherToDatabase({
    required Weather weather,
    required String dbUserID,
  }) async {
    // Convert the Weather object to a Map using toJson
    final weatherData = weather.toJson();
    // Add the weather data to Firestore with an auto-generated document ID
    await weatherRef.doc(dbUserID).set(weatherData);
  }

  Future<List<City>> getCitiesFromAPi(String inputQuery) async {
    // use a uri object instead of a direct url
    final Uri uri = Uri(
      // we're basically building the url piece by piece
      scheme: 'https',
      host: 'api.weatherapi.com',
      path: '/v1/search.json',
      queryParameters: {
        'key': dotenv.env['APPID'],
        'q': inputQuery,
      },
    );
    try {
      // retrieve a response body from the uri
      final http.Response response = await httpClient.get(uri);

      // create and throw a http error status exception object
      // we will handle this at a higher level
      if (response.statusCode != 200) {
        throw HttpErrorStatusException(
          responseMessage:
              'HttpErrorStatusException\nStatus Code: ${response.statusCode}\nResponse Message: ${response.reasonPhrase}',
        );
      }
      // else - decode the response
      final List<dynamic> responseBody = json.decode(response.body);

      // handle this weather exception at the calling level - bloc level
      if (responseBody.isEmpty) {
        throw WeatherApiException(
            message:
                'WeatherApiException: Cannot get the list of cities for: $inputQuery');
      }

      // build a list of cities from our response body
      final List<City> cities = responseBody
          .map((responseObject) => City.fromJson(responseObject))
          .toList();

      // return our list of city objects
      return cities;
    } catch (e) {
      // catch all exceptions (those written in the try block and those not accounted for)
      // we will convert all errors to a generic error
      throw GenericError(message: e);
    }
  }
}
