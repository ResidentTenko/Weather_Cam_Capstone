import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_capstone_weather/errors/generic_error.dart';
import 'package:my_capstone_weather/errors/http_error_status_exception.dart';
import 'package:my_capstone_weather/errors/weather_api_exception.dart';
import 'package:my_capstone_weather/models/city_model.dart';
import 'package:my_capstone_weather/models/weather.dart';

class ApiWeatherServices {
  final http.Client httpClient;
  // constructor
  ApiWeatherServices({required this.httpClient});
  // takes a string and returns a weather type object wrapped in a future
  Future<Weather> getWeatherFromApi(String inputQuery) async {
    // use a uri object instead of a direct url
    final Uri uri = Uri(
      // we're basically building the url piece by piece
      scheme: 'https',
      host: 'api.weatherapi.com',
      path: '/v1/forecast.json',
      queryParameters: {
        'key': dotenv.env['APPID'],
        'q': inputQuery,
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
                'WeatherApiException: Cannot get the weather information of: $inputQuery');
      }

      // feed the response bodyto our weather object and build a weather object
      final Weather weather = Weather.fromJson(responseBody);

      // return our weather object
      return weather;
    } catch (e) {
      // catch all exceptions (those written in the try block and those not accounted for)
      // we will convert all errors to a generic error
      throw GenericError(message: e);
    }
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