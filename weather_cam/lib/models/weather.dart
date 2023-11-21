// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_application/models/forecast.dart';
import 'package:flutter_application/models/hourly_model.dart';

class Weather extends Equatable {
  final String name;
  final String country;
  final String condition;
  final String region;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final double feelsLike;
  final int humidity;
  final double visibility;
  final double windSpeed;
  final String windDirection;
  final double uv;
  final double pressure;
  // never replace the icon with forecast icon - forecast current condition is not always the same as actual condition
  final String icon;
  final int date;
  final int localTime;
  final String timezone;
  final List<Forecast> forecast;
  final List<Hourly> hourly;

  const Weather({
    required this.name,
    required this.country,
    required this.region,
    required this.condition,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDirection,
    required this.uv,
    required this.pressure,
    required this.icon,
    required this.date,
    required this.localTime,
    required this.timezone,
    required this.forecast,
    required this.hourly,
  });

  // second default constructor
  factory Weather.initial() {
    return const Weather(
      name: 'Blank City',
      country: 'Blank Country',
      region: 'Blank Region',
      condition: 'Unknown',
      temp: 200.0,
      maxTemp: 300.0,
      minTemp: 0.0,
      humidity: 0,
      visibility: 0.0,
      windSpeed: 0.0,
      windDirection: "True North",
      uv: 0.0,
      pressure: 0,
      feelsLike: 300.0,
      icon: 'No Icon',
      date: 0,
      localTime: 0,
      timezone: "",
      forecast: [],
      hourly: [],
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
    // get our list data
    final forecast = forecastList.map(
      (forecastItem) {
        return Forecast.fromApiJson(forecastItem as Map<String, dynamic>);
      },
    ).toList();

    // Combine hours using a static method
    final combinedHours = combineHoursFromForecasts(forecast);

    return Weather(
      name: location['name'] as String,
      country: location['country'] as String,
      region: location['region'] as String,
      condition: current['condition']['text'] as String,
      temp: current['temp_f'] as double,
      maxTemp: forecastday_0['day']['maxtemp_f'] as double,
      minTemp: forecastday_0['day']['mintemp_f'] as double,
      feelsLike: current['feelslike_f'] as double,
      humidity: current['humidity'],
      visibility: current['vis_miles'],
      windDirection: current['wind_dir'],
      windSpeed: current['wind_mph'],
      uv: current['uv'],
      pressure: current['pressure_mb'],
      icon: current['condition']['icon'] as String,
      date: forecastday_0['date_epoch'] as int,
      localTime: location['localtime_epoch'] as int,
      timezone: location['tz_id'] as String,
      // take the list from the json, convert each item in the list to a Map<String, dynamic>
      // then convert that to our model using the fromJson function of forecast
      // take the returned model and make a list of forcast object
      forecast: forecast,
      hourly: combinedHours,
    );
  }

  static List<Hourly> combineHoursFromForecasts(List<Forecast> forecasts) {
    List<Hourly> combinedHours = [];

    for (var forecast in forecasts) {
      combinedHours.addAll(forecast.hourly);
    }
    return combinedHours;
  }

  // construtor that we will use when loading values from the hydrated storage
  factory Weather.fromStorageJson(Map<String, dynamic> json) {
    final tempValue = json['temp'];
    final maxTempValue = json['maxTemp'];
    final minTempValue = json['minTemp'];
    final feelsLikeValue = json['feelsLike'];
    final humidityValue = json['humidity'];
    final visibilityValue = json['visibility'];
    final windSpeedValue = json['windSpeed'];
    final uvValue = json['uv'];
    final pressureValue = json['pressure'];
    final storageForecastList = json['forecast'] as List<dynamic>;
    final hourlyForecastList = json['hourly'] as List<dynamic>;
    return Weather(
      name: json['name'] as String,
      country: json['country'] as String,
      condition: json['condition'] as String,
      region: json['region'] as String,
      icon: json['icon'] as String,
      date: json['date'] as int,
      localTime: json['localTime'] as int,
      timezone: json['timezone'] as String,
      windDirection: json['windDirection'] as String,
      forecast: storageForecastList.map(
        (forecastItem) {
          return Forecast.fromStorageJson(forecastItem as Map<String, dynamic>);
        },
      ).toList(),
      hourly: hourlyForecastList.map(
        (hourlyItem) {
          return Hourly.fromStorageJson(hourlyItem as Map<String, dynamic>);
        },
      ).toList(),
      temp: tempValue is num ? tempValue.toDouble() : 0.0,
      maxTemp: maxTempValue is num ? maxTempValue.toDouble() : 0.0,
      minTemp: minTempValue is num ? minTempValue.toDouble() : 0.0,
      feelsLike: feelsLikeValue is num ? feelsLikeValue.toDouble() : 0.0,
      humidity: humidityValue is num ? humidityValue.toInt() : 0,
      visibility: visibilityValue is num ? visibilityValue.toDouble() : 0.0,
      windSpeed: windSpeedValue is num ? windSpeedValue.toDouble() : 0.0,
      uv: uvValue is num ? uvValue.toDouble() : 0.0,
      pressure: pressureValue is num ? pressureValue.toDouble() : 0.0,
    );
  }

  // construtor that we will use when loading values from the snapshot downloaded from firebase
  factory Weather.fromFBDatabase(Map<String, dynamic> json) {
    // a nullable type object is returned so cast it as a nullable map type
    final dbWeatherData = json['weather'];
    // grab the list under the keyword forecasts
    final dbWeatherForecastList = json['forecasts'] as List<dynamic>;
    // grab the list under the keyword hourly
    final dbHourlyList = json['hourly'] as List<dynamic>;
    final tempValue = dbWeatherData['temp'];
    final maxTempValue = dbWeatherData['maxTemp'];
    final minTempValue = dbWeatherData['minTemp'];
    final feelsLikeValue = dbWeatherData['feelsLike'];
    final humidityValue = dbWeatherData['humidity'];
    final visibilityValue = dbWeatherData['visibility'];
    final windSpeedValue = dbWeatherData['windSpeed'];
    final uvValue = dbWeatherData['uv'];
    final pressureValue = dbWeatherData['pressure'];

    return Weather(
      name: dbWeatherData['name'] as String,
      country: dbWeatherData['country'] as String,
      region: dbWeatherData['region'] as String,
      condition: dbWeatherData['condition'] as String,
      windDirection: dbWeatherData['windDirection'] as String,
      icon: dbWeatherData['icon'] as String,
      date: dbWeatherData['date'] as int,
      localTime: dbWeatherData['localTime'] as int,
      timezone: dbWeatherData['timezone'] as String,
      forecast: dbWeatherForecastList.map(
        (forecastItem) {
          return Forecast.fromFBDatabase(forecastItem as Map<String, dynamic>);
        },
      ).toList(),
      hourly: dbHourlyList.map(
        (hourlyItem) {
          return Hourly.fromFBDatabase(hourlyItem as Map<String, dynamic>);
        },
      ).toList(),
      temp: tempValue is num ? tempValue.toDouble() : 0.0,
      maxTemp: maxTempValue is num ? maxTempValue.toDouble() : 0.0,
      minTemp: minTempValue is num ? minTempValue.toDouble() : 0.0,
      feelsLike: feelsLikeValue is num ? feelsLikeValue.toDouble() : 0.0,
      humidity: humidityValue is num ? humidityValue.toInt() : 0,
      visibility: visibilityValue is num ? visibilityValue.toDouble() : 0.0,
      windSpeed: windSpeedValue is num ? windSpeedValue.toDouble() : 0.0,
      uv: uvValue is num ? uvValue.toDouble() : 0.0,
      pressure: pressureValue is num ? pressureValue.toDouble() : 0.0,
    );
  }

  // convert our forecast model back to Json (Used only for FB)
  // The return is a map with String keys and dynamic values
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'region': region,
      'condition': condition,
      'temp': temp,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'visibility': visibility,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'uv': uv,
      'pressure': pressure,
      'icon': icon,
      'date': date,
      'localTime': localTime,
      'timezone': timezone,
    };
  }

  // convert our forecast model back to Json for local Stroage
  Map<String, dynamic> toStorageJson() {
    return {
      'name': name,
      'country': country,
      'region': region,
      'condition': condition,
      'temp': temp,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'visibility': visibility,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'uv': uv,
      'pressure': pressure,
      'icon': icon,
      'date': date,
      'localTime': localTime,
      'timezone': timezone,
      'forecast':
          forecast.map((forecastItem) => forecastItem.toJson()).toList(),
      'hourly': hourly.map((hourlyItem) => hourlyItem.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Weather Model Data-: (name: $name, country: $country, region: $region, condition: $condition, temp: $temp, maxTemp: $maxTemp, minTemp: $minTemp, feelsLike: $feelsLike, icon: $icon, date: $date, localTime, $localTime, timezone: $timezone, forecast: $forecast, hourly: $hourly)';
  }

  @override
  List<Object> get props {
    return [
      name,
      country,
      region,
      condition,
      temp,
      maxTemp,
      minTemp,
      feelsLike,
      humidity,
      visibility,
      windSpeed,
      windDirection,
      uv,
      pressure,
      icon,
      date,
      localTime,
      timezone,
      forecast,
      hourly,
    ];
  }

  Weather copyWith({
    String? name,
    String? country,
    String? region,
    String? condition,
    double? temp,
    double? maxTemp,
    double? minTemp,
    double? feelsLike,
    int? humidity,
    double? visibility,
    double? windSpeed,
    String? windDirection,
    double? uv,
    double? pressure,
    String? icon,
    int? date,
    int? localTime,
    String? timezone,
    List<Forecast>? forecast,
    List<Hourly>? hourly,
  }) {
    return Weather(
      name: name ?? this.name,
      country: country ?? this.country,
      region: region ?? this.region,
      condition: condition ?? this.condition,
      temp: temp ?? this.temp,
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      visibility: visibility ?? this.visibility,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      uv: uv ?? this.uv,
      pressure: pressure ?? this.pressure,
      icon: icon ?? this.icon,
      date: date ?? this.date,
      localTime: localTime ?? this.localTime,
      timezone: timezone ?? this.timezone,
      forecast: forecast ?? this.forecast,
      hourly: hourly ?? this.hourly,
    );
  }
}
