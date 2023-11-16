// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/constants/db_constant.dart';
import 'package:flutter_application/errors/generic_error.dart';
import 'package:flutter_application/errors/http_error_status_exception.dart';
import 'package:flutter_application/errors/weather_api_exception.dart';
import 'package:flutter_application/models/city_model.dart';
import 'package:flutter_application/models/forecast.dart';
import 'package:flutter_application/models/hourly_model.dart';
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
      // Fetch weather data
      final DocumentSnapshot weatherDoc = await weatherRef.doc(dbUserID).get();

      if (!weatherDoc.exists) {
        throw const GenericError(message: "Weather information does not exist");
      }

      final weatherData = weatherDoc.data() as Map<String, dynamic>;

      // add the value to the results map
      Map<String, dynamic> result = {'weather': weatherData};

      // Fetch forecast data
      final DocumentSnapshot forecastDoc =
          await forecastRef.doc(dbUserID).get();

      if (forecastDoc.exists) {
        final forecastData = forecastDoc.data() as Map<String, dynamic>;
        result['forecasts'] = forecastData['forecasts'];
      } else {
        result['forecasts'] = []; // Empty array if forecast data doesn't exist
      }

      // Fetch forecast data
      final DocumentSnapshot hourlyDoc = await hourlyRef.doc(dbUserID).get();

      if (hourlyDoc.exists) {
        final hourlyData = hourlyDoc.data() as Map<String, dynamic>;
        // Ensure 'hourly' key exists in the map before accessing its value
        result['hourly'] =
            hourlyData.containsKey('hourly') ? hourlyData['hourly'] : [];
      } else {
        result['hourly'] = [];
      }

      final weather = Weather.fromFBDatabase(result);

      return weather;
    } catch (e) {
      throw GenericError(message: e.toString());
    }
  }

  Future<void> addWeatherToDatabase({
    required Weather weather,
    required List<Forecast> forecast,
    required List<Hourly> hourly,
    required String dbUserID,
  }) async {
    // Convert the Weather object to a Map using toJson
    final weatherData = weather.toJson();

    final forecastDataList =
        forecast.map((forecastItem) => forecastItem.toJson()).toList();

    final hourlyDataList =
        hourly.map((hourlyItem) => hourlyItem.toJson()).toList();

    try {
      // Add the weather data to Firestore with an auto-generated document ID
      await weatherRef.doc(dbUserID).set(weatherData);

      // Add the forecast data to Firestore with an auto-generated document ID
      await forecastRef.doc(dbUserID).set({'forecasts': forecastDataList});

      // Add the hourly data to Firestore with an auto-generated document ID
      await hourlyRef.doc(dbUserID).set({'hourly': hourlyDataList});
    } catch (e) {
      print('Error adding weather data: $e');
    }
  }

/**
 * Future<void> addWeatherToDatabase({
  required Weather weather,
  required List<Forecast> forecast,
  required String dbUserID,
}) async {
  // Convert the Weather object to a Map using toJson
  final weatherData = weather.toJson();

  // Convert the forecast objects to a List of Maps using toJson
  final forecastDataList = forecast.map((forecastItem) => forecastItem.toJson()).toList();

  // Add the weather data and forecast list to Firestore in the same document
  await forecastRef.doc(dbUserID).set({
    'weather': weatherData,
    'forecasts': forecastDataList,
  });
}
 */

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
