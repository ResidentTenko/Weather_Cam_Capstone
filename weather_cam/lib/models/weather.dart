// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:my_capstone_weather/models/forecast.dart';

class Weather extends Equatable {
  final String name;
  final String country;
  final String condition;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final double feelsLike;
  // never replace the icon with forecast icon - forecast current condition is not always the same as actual condition
  final String icon;
  final List<Forecast> forecast;
  final DateTime lastUpdated;

  const Weather({
    required this.name,
    required this.country,
    required this.condition,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.icon,
    required this.forecast,
    required this.lastUpdated,
  });

  // second default constructor
  factory Weather.initial() {
    return Weather(
      name: 'Blank City',
      country: 'Blank Country',
      condition: 'Unknown',
      temp: 200.0,
      maxTemp: 300.0,
      minTemp: 0.0,
      feelsLike: 300.0,
      icon: 'No Icon',
      forecast: const [],
      lastUpdated: DateTime(2000),
    );
  }

  // construtor that we will use when loading values from Json
  factory Weather.fromJson(Map<String, dynamic> json) {
    // grab the values under the keyname location
    final location = json['location'];
    // grab the values under the keyname current
    final current = json['current'];
    // grab the values under the keyname forecast
    // grab the first item in the list under the keyname forecast day
    final forecastday_0 = json['forecast']['forecastday'][0];
    // grab the list under the keyword forecastday
    final forecastList = json['forecast']['forecastday'] as List<dynamic>;

    return Weather(
      name: location['name'],
      country: location['country'],
      condition: current['condition']['text'],
      temp: current['temp_f'],
      maxTemp: forecastday_0['day']['maxtemp_f'],
      minTemp: forecastday_0['day']['mintemp_f'],
      feelsLike: current['feelslike_f'],
      icon: current['condition']['icon'],
      lastUpdated: DateTime.now(),
      // map each forecast item to a Forecast object
      forecast: forecastList.map((forecastItem) {
        return Forecast.fromJson(forecastItem as Map<String, dynamic>);
      }).toList(), // then create a list of forecast objects
    );
  }

  @override
  List<Object> get props {
    return [
      name,
      country,
      condition,
      temp,
      maxTemp,
      minTemp,
      feelsLike,
      icon,
      forecast,
      lastUpdated,
    ];
  }

  @override
  String toString() {
    return 'Weather(name: $name, country: $country, condition: $condition, temp: $temp, maxTemp: $maxTemp, minTemp: $minTemp, feelsLike: $feelsLike, icon: $icon, \n forecast: $forecast, lastUpdated: $lastUpdated)';
  }

  Weather copyWith({
    String? name,
    String? country,
    String? condition,
    double? temp,
    double? maxTemp,
    double? minTemp,
    double? feelsLike,
    String? icon,
    List<Forecast>? forecast,
    DateTime? lastUpdated,
  }) {
    return Weather(
      name: name ?? this.name,
      country: country ?? this.country,
      condition: condition ?? this.condition,
      temp: temp ?? this.temp,
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      feelsLike: feelsLike ?? this.feelsLike,
      icon: icon ?? this.icon,
      forecast: forecast ?? this.forecast,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
