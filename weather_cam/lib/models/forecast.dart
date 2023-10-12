// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Forecast extends Equatable {
  final double maxTemp;
  final double minTemp;
  final String icon;
  final String forecastDay;
  const Forecast({
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
    required this.forecastDay,
  });

  factory Forecast.initial() {
    return const Forecast(
      maxTemp: 6000.0,
      minTemp: 0.00,
      icon: '',
      forecastDay: '00/00/0000',
    );
  }

  // construtor that we will use when loading values from Json
  factory Forecast.fromJson(Map<String, dynamic> json) {
    // we don't need to dig down any further since we are fed a list that has already dug down to the level we need
    // we instead dig from the current level
    return Forecast(
      maxTemp: json['day']['maxtemp_f'],
      minTemp: json['day']['mintemp_f'],
      icon: json['day']['condition']['icon'],
      forecastDay: DateFormat('E').format(
        DateTime.fromMillisecondsSinceEpoch(
          json['date_epoch'] * 1000,
          isUtc: true,
        ),
      ),
    );
  }

  // convert our forecast model back to Json
  // The return is a map with String keys and dynamic values 
  Map<String, dynamic> toJson() {
    return {
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'icon': icon,
      'forecastDay': forecastDay,
    };
  }

  @override
  List<Object> get props => [maxTemp, minTemp, icon];

  @override
  String toString() {
    return ('maxTemp: $maxTemp, minTemp: $minTemp, icon: $icon, forecastDay: $forecastDay');
  }

  Forecast copyWith({
    double? maxTemp,
    double? minTemp,
    String? icon,
    String? forecastDay,
  }) {
    return Forecast(
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      icon: icon ?? this.icon,
      forecastDay: forecastDay ?? this.forecastDay,
    );
  }
}
