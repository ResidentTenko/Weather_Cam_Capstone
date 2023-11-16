// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Hourly extends Equatable {
  final int hourlyTime;
  final double hourlyTemp;
  final String hourlyIcon;
  const Hourly({
    required this.hourlyTime,
    required this.hourlyTemp,
    required this.hourlyIcon,
  });

  factory Hourly.initial() {
    return const Hourly(
      hourlyTime: 0,
      hourlyTemp: 0.0,
      hourlyIcon: '',
    );
  }

  // construtor that we will use when loading values from Api Json
  factory Hourly.fromApiJson(Map<String, dynamic> json) {
   
    return Hourly(
      hourlyTime: json['time_epoch'],
      hourlyTemp: json['temp_f'],
      hourlyIcon: json['condition']['icon'],
    );
  }

  // construtor that we will use when loading values from local storage json
  factory Hourly.fromStorageJson(Map<String, dynamic> json) {
    final temp = json['hourlyTemp'];
    
    return Hourly(
      hourlyTime: json['hourlyTime'] as int,
      hourlyTemp: temp is num ? temp.toDouble() : 0.0,
      hourlyIcon: json['hourlyIcon'] as String,
    );
  }

  // construtor that we will use when loading values from firestore
  factory Hourly.fromFBDatabase(Map<String, dynamic> dbData) {
    final temp = dbData['hourlyTemp'];
  
    return Hourly(
      hourlyTime: dbData['hourlyTime'] as int,
      hourlyTemp: temp is num ? temp.toDouble() : 0.0,
      hourlyIcon: dbData['hourlyIcon'] as String,
    );
  }

  // convert our forecast model back to Json
  // The return is a map with String keys and dynamic values
  Map<String, dynamic> toJson() {
    return {
      'hourlyTime': hourlyTime,
      'hourlyTemp': hourlyTemp,
      'hourlyIcon': hourlyIcon,
    };
  }

  @override
  List<Object> get props => [hourlyTime, hourlyTemp, hourlyIcon];

  @override
  String toString() => 'Hourly Model Data-: (hourlyTime: $hourlyTime, hourlyTemp: $hourlyTemp, hourlyIcon: $hourlyIcon)';

  Hourly copyWith({
    int? hourlyTime,
    double? hourlyTemp,
    String? hourlyIcon,
  }) {
    return Hourly(
      hourlyTime: hourlyTime ?? this.hourlyTime,
      hourlyTemp: hourlyTemp ?? this.hourlyTemp,
      hourlyIcon: hourlyIcon ?? this.hourlyIcon,
    );
  }
}
