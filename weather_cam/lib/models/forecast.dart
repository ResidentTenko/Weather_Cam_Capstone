import 'package:equatable/equatable.dart';
import 'package:flutter_application/models/hourly_model.dart';

class Forecast extends Equatable {
  final double forecastMaxTemp;
  final double forecastMinTemp;
  final String forecastConditon;
  final String forecastIcon;
  final int forecastDate;
  final List<Hourly> hourly;

  const Forecast({
    required this.forecastMaxTemp,
    required this.forecastMinTemp,
    required this.forecastConditon,
    required this.forecastIcon,
    required this.forecastDate,
    required this.hourly,
  });

  factory Forecast.initial() {
    return const Forecast(
      forecastMaxTemp: 6000.0,
      forecastMinTemp: 0.00,
      forecastConditon: '',
      forecastIcon: '',
      forecastDate: 0,
      hourly: [],
    );
  }

  // construtor that we will use when loading values from Api Json
  factory Forecast.fromApiJson(Map<String, dynamic> json) {
    // we don't need to dig down any further since we are fed a list that has already dug down to the level we need
    // we instead dig from the current level
    final dailyValues = json['day'];
    final hourlyValues = json['hour'] as List<dynamic>;

    return Forecast(
      forecastMaxTemp: dailyValues['maxtemp_f'] as double,
      forecastMinTemp: dailyValues['mintemp_f'] as double,
      forecastConditon: dailyValues['condition']['text'] as String,
      forecastIcon: dailyValues['condition']['icon'] as String,
      forecastDate: json['date_epoch'] as int,
      hourly: hourlyValues.map(
        (hourlyItem) {
          return Hourly.fromApiJson(hourlyItem as Map<String, dynamic>);
        },
      ).toList(),
    );
  }

  // construtor that we will use when loading values from local storage json
  factory Forecast.fromStorageJson(Map<String, dynamic> json) {
    final forecastMaxTemp = json['forecastMaxTemp'];
    final forecastMinTemp = json['forecastMinTemp'];
    return Forecast(
      forecastConditon: json['forecastConditon'] as String,
      forecastIcon: json['forecastIcon'] as String,
      forecastDate: json['forecastDate'] as int,
      forecastMaxTemp:
          forecastMaxTemp is num ? forecastMaxTemp.toDouble() : 0.0,
      forecastMinTemp:
          forecastMinTemp is num ? forecastMinTemp.toDouble() : 0.0,
      hourly: const [],
    );
  }

  factory Forecast.fromFBDatabase(Map<String, dynamic> dbData) {
    //// I figured out the data bug. Firebase firestore stores doubles with their decimal representation internally
    /// However the console won't show the decimal representation. Double 91 when sent to the DB is stored as 91.0
    /// But shows up as 91 in the console. By extension when I change a double 81.5 to an int in the console 82, the internal code
    /// has a discrepancy because it is expecting double values. The console itself won't show me the error
    /// So let me account for any num changes on the datbase end

    final forecastMaxTemp = dbData['forecastMaxTemp'];
    final forecastMinTemp = dbData['forecastMinTemp'];

    return Forecast(
      forecastConditon: dbData['forecastConditon'] as String,
      forecastIcon: dbData['forecastIcon'] as String,
      forecastDate: dbData['forecastDate'] as int,
      forecastMaxTemp:
          forecastMaxTemp is num ? forecastMaxTemp.toDouble() : 0.0,
      forecastMinTemp:
          forecastMinTemp is num ? forecastMinTemp.toDouble() : 0.0,
      hourly: const [],
    );
  }

  // convert our forecast model back to Json
  // The return is a map with String keys and dynamic values
  Map<String, dynamic> toJson() {
    return {
      'forecastMaxTemp': forecastMaxTemp,
      'forecastMinTemp': forecastMinTemp,
      'forecastConditon': forecastConditon,
      'forecastIcon': forecastIcon,
      'forecastDate': forecastDate,
    };
  }

  @override
  List<Object> get props =>
      [forecastMaxTemp, forecastMinTemp, forecastConditon, forecastIcon];

  @override
  String toString() {
    return 'Forecast Model Data-: (forecastMaxTemp: $forecastMaxTemp, forecastMinTemp: $forecastMinTemp, forecastIcon: $forecastIcon, forecastConditon: $forecastConditon, forecastDate: $forecastDate, hourly: $hourly)';
  }

  Forecast copyWith({
    double? forecastMaxTemp,
    double? forecastMinTemp,
    String? forecastConditon,
    String? forecastIcon,
    int? forecastDate,
    List<Hourly>? hourly,
  }) {
    return Forecast(
      forecastMaxTemp: forecastMaxTemp ?? this.forecastMaxTemp,
      forecastMinTemp: forecastMinTemp ?? this.forecastMinTemp,
      forecastConditon: forecastConditon ?? this.forecastConditon,
      forecastIcon: forecastIcon ?? this.forecastIcon,
      forecastDate: forecastDate ?? this.forecastDate,
      hourly: hourly ?? this.hourly,
    );
  }
}
