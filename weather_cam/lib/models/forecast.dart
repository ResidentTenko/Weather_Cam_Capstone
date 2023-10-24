import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final double maxTemp;
  final double minTemp;
  final String icon;
  final int forecastDate;
  const Forecast({
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
    required this.forecastDate,
  });

  factory Forecast.initial() {
    return const Forecast(
      maxTemp: 6000.0,
      minTemp: 0.00,
      icon: '',
      forecastDate: 0,
    );
  }

  // construtor that we will use when loading values from Json
  factory Forecast.fromApiJson(Map<String, dynamic> json) {
    // we don't need to dig down any further since we are fed a list that has already dug down to the level we need
    // we instead dig from the current level
    return Forecast(
      maxTemp: json['day']['maxtemp_f'] as double,
      minTemp: json['day']['mintemp_f'] as double,
      icon: json['day']['condition']['icon'] as String,
      forecastDate: json['date_epoch'] as int,
    );
  }

  factory Forecast.fromStorageJson(Map<String, dynamic> json) {
    final maxTemp = json['maxTemp'];
    final minTemp = json['minTemp'];
    return Forecast(
      icon: json['icon'] as String,
      forecastDate: json['forecastDate'] as int,
      maxTemp: maxTemp is num ? maxTemp.toDouble() : 0.0,
      minTemp: minTemp is num ? minTemp.toDouble() : 0.0,
    );
  }

  factory Forecast.fromFBDatabase(Map<String, dynamic> dbData) {
    //// I figured out the data bug. Firebase firestore stores doubles with their decimal representation internally
    /// However the console won't show the decimal representation. Double 91 when sent to the DB is stored as 91.0
    /// But shows up as 91 in the console. By extension when I change a double 81.5 to an int in the console 82, the internal code
    /// has a discrepancy because it is expecting double values. The console itself won't show me the error
    /// So let me account for any num changes on the datbase end

    final maxTemp = dbData['maxTemp'];
    final minTemp = dbData['minTemp'];
    return Forecast(
      icon: dbData['icon'] as String,
      forecastDate: dbData['forecastDate'] as int,
      maxTemp: maxTemp is num ? maxTemp.toDouble() : 0.0,
      minTemp: minTemp is num ? minTemp.toDouble() : 0.0,
    );
  }

  // convert our forecast model back to Json
  // The return is a map with String keys and dynamic values
  Map<String, dynamic> toJson() {
    return {
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'icon': icon,
      'forecastDate': forecastDate,
    };
  }

  @override
  List<Object> get props => [maxTemp, minTemp, icon];

  @override
  String toString() {
    return ('maxTemp: $maxTemp, minTemp: $minTemp, icon: $icon, forecastDate: $forecastDate');
  }

  Forecast copyWith({
    double? maxTemp,
    double? minTemp,
    String? icon,
    int? forecastDate,
  }) {
    return Forecast(
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      icon: icon ?? this.icon,
      forecastDate: forecastDate ?? this.forecastDate,
    );
  }
}
