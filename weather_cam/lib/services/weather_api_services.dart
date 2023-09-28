// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_capstone_weather/models/city_model.dart';
import 'package:my_capstone_weather/models/weather.dart';
import 'package:my_capstone_weather/services/http_error_handler.dart';

class WeatherApiServices {
  // takes a string and returns a weather type object wrapped in a future
  Future<Weather> getWeather(String inputQuery) async {
    // create http.client object
    http.Client httpClient = http.Client();
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

      // throw error message if get request fails
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      // else - decode the response
      final responseBody = json.decode(response.body);

      // feed the response bodyto our weather object and build a weather object
      final Weather weather = Weather.fromJson(responseBody);

      // return our weather object
      return weather;
    } catch (e) {
      // throw any other type of errors back to the calling side without any special handling
      // pass it up to a higher level of the program where it can be dealt with more appropriately or where it makes sense to handle the exception.
      rethrow;
    }
  }

  Future<List<City>> getCities(String inputQuery) async {
    // create http.client object
    http.Client httpClient = http.Client();
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

      // throw error message if get request fails
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      // else - decode the response
      final List<dynamic> responseBody = json.decode(response.body);

      // build a list of cities from our response body
      final List<City> cities = responseBody
          .map((responseObject) => City.fromJson(responseObject))
          .toList();

      // return our list of city objects
      return cities;
    } catch (e) {
      rethrow;
    }
  }
}
