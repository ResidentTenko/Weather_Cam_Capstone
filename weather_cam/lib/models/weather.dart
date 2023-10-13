// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/models/forecast.dart';

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
  final DateTime date;

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
    required this.date,
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
      date: DateTime.now(),
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
      date: DateTime.fromMillisecondsSinceEpoch(
        forecastday_0['date_epoch'] * 1000,
        isUtc: true,
      ),
      // take the list from the json, convert each item in the list to a Map<String, dynamic>
      // then convert that to our model using the fromJson function of forecast
      // take the returned model and make a list of forcast object
      forecast: forecastList.map((forecastItem) {
        return Forecast.fromJson(forecastItem as Map<String, dynamic>);
      }).toList(), // then create a list of forecast objects
    );
  }

  factory Weather.fromDoc(DocumentSnapshot weatherDoc) {
    // placeholder
    return Weather.initial();
  }

  // convert our forecast model back to Json
  // The return is a map with String keys and dynamic values
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'condition': condition,
      'temp': temp,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'feelsLike': feelsLike,
      'icon': icon,
      'date': date,
      // take each forecast object from the forecast list
      // send them to the toJson function of forecast - this function converts each object to a Map<String, dynamic>
      // Each map is then returned and added to a list in the form of forecast: [{},{},{}]
      // so forecast is the key word and it has a list of maps as the value
      'forecast':
          forecast.map((forecastItem) => forecastItem.toJson()).toList(),
    };
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
      date,
    ];
  }

  @override
  String toString() {
    return 'Weather(name: $name, country: $country, condition: $condition, temp: $temp, maxTemp: $maxTemp, minTemp: $minTemp, feelsLike: $feelsLike, icon: $icon, \n forecast: $forecast, date: $date)';
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
    DateTime? date,
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
      date: date ?? this.date,
    );
  }
}
