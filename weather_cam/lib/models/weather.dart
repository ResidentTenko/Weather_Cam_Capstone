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
  final int date;
  final List<Forecast> forecast;

  const Weather({
    required this.name,
    required this.country,
    required this.condition,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.icon,
    required this.date,
    required this.forecast,
  });

  // second default constructor
  factory Weather.initial() {
    return const Weather(
      name: 'Blank City',
      country: 'Blank Country',
      condition: 'Unknown',
      temp: 200.0,
      maxTemp: 300.0,
      minTemp: 0.0,
      feelsLike: 300.0,
      icon: 'No Icon',
      date: 0,
      forecast: [],
    );
  }

  // construtor that we will use when loading values from Json downloaded from the API
  factory Weather.fromApiJson(Map<String, dynamic> json) {
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
      name: location['name'] as String,
      country: location['country'] as String,
      condition: current['condition']['text'] as String,
      temp: current['temp_f'] as double,
      maxTemp: forecastday_0['day']['maxtemp_f'] as double,
      minTemp: forecastday_0['day']['mintemp_f'] as double,
      feelsLike: current['feelslike_f'] as double,
      icon: current['condition']['icon'] as String,
      date: location['localtime_epoch'] as int,
      // take the list from the json, convert each item in the list to a Map<String, dynamic>
      // then convert that to our model using the fromJson function of forecast
      // take the returned model and make a list of forcast object
      forecast: forecastList.map(
        (forecastItem) {
          return Forecast.fromApiJson(forecastItem as Map<String, dynamic>);
        },
      ).toList(), // then create a list of forecast objects
    );
  }

  // construtor that we will use when loading values from the snapshot downloaded from firebase
  factory Weather.fromStorageJson(Map<String, dynamic> json) {

    final tempValue = json['temp'];
    final maxTempValue = json['maxTemp'];
    final minTempValue = json['minTemp'];
    final feelsLikeValue = json['feelsLike'];
    final storageForecastList = json['forecast'] as List<dynamic>;

    return Weather(
      name: json['name'] as String,
      country: json['country'] as String,
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      date: json['date'] as int,
      forecast: storageForecastList.map(
        (forecastItem) {
          return Forecast.fromStorageJson(forecastItem as Map<String, dynamic>);
        },
      ).toList(),
      temp: tempValue is num ? tempValue.toDouble() : 0.0,
      maxTemp: maxTempValue is num ? maxTempValue.toDouble() : 0.0,
      minTemp: minTempValue is num ? minTempValue.toDouble() : 0.0,
      feelsLike: feelsLikeValue is num ? feelsLikeValue.toDouble() : 0.0,
    );
  }

  // construtor that we will use when loading values from the snapshot downloaded from firebase
  factory Weather.fromFBDatabase(DocumentSnapshot weatherDoc) {
    // a nullable type object is returned so cast it as a nullable map type
    final dbWeatherData = weatherDoc.data() as Map<String, dynamic>?;
    // grab the list under the keyword forecast
    final dbWeatherForecastList = dbWeatherData!['forecast'] as List<dynamic>;
    // the database has a list of Map<String, dyanmic> under the keyword forecast

    final tempValue = dbWeatherData['temp'];
    final maxTempValue = dbWeatherData['maxTemp'];
    final minTempValue = dbWeatherData['minTemp'];
    final feelsLikeValue = dbWeatherData['feelsLike'];

    return Weather(
      name: dbWeatherData['name'] as String,
      country: dbWeatherData['country'] as String,
      condition: dbWeatherData['condition'] as String,
      icon: dbWeatherData['icon'] as String,
      date: dbWeatherData['date'] as int,
      forecast: dbWeatherForecastList.map(
        (forecastItem) {
          return Forecast.fromFBDatabase(forecastItem as Map<String, dynamic>);
        },
      ).toList(),
      temp: tempValue is num ? tempValue.toDouble() : 0.0,
      maxTemp: maxTempValue is num ? maxTempValue.toDouble() : 0.0,
      minTemp: minTempValue is num ? minTempValue.toDouble() : 0.0,
      feelsLike: feelsLikeValue is num ? feelsLikeValue.toDouble() : 0.0,
    );
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
      //  date,
    ];
  }

  @override
  String toString() {
    return 'Weather(name: $name, country: $country, condition: $condition, temp: $temp, maxTemp: $maxTemp, minTemp: $minTemp, feelsLike: $feelsLike, icon: $icon, , date: $date, forecast: $forecast)';
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
    int? date,
    List<Forecast>? forecast,
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
      date: date ?? this.date,
      forecast: forecast ?? this.forecast,
    );
  }
}
// date: DateTime.fromMillisecondsSinceEpoch(forecastday_0['date_epoch'] * 1000,isUtc: true,),