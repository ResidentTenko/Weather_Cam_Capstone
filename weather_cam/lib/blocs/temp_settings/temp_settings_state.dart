// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'temp_settings_cubit.dart';

enum TempUnit {
  fahrenheit,
  celsius;

  String toJson() => name;

  static TempUnit fromJson(String json) => values.byName(json);
}

enum MeasurementUnit {
  miles,
  kilometers;

  String toJson() => name;

  static MeasurementUnit fromJson(String json) => values.byName(json);
}

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;
  final MeasurementUnit measurementUnit;

  const TempSettingsState({
    this.tempUnit = TempUnit.fahrenheit,
    this.measurementUnit = MeasurementUnit.miles,
  });

  factory TempSettingsState.initial() {
    return const TempSettingsState();
  }

  @override
  List<Object> get props => [tempUnit, measurementUnit];

  @override
  String toString() =>
      'TempSettingsState(tempUnit: $tempUnit, measurementUnit: $measurementUnit)';

  TempSettingsState copyWith({
    TempUnit? tempUnit,
    MeasurementUnit? measurementUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }

  // Called when converting the state to a map (think of it in terms of JSON)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tempUnit': tempUnit.toJson(),
      'measurementUnit': measurementUnit.toJson(),
    };
  }

  // Called when converting the storage JSON back to a state object
  factory TempSettingsState.fromJson(Map<String, dynamic> json) {
    return TempSettingsState(
      tempUnit: TempUnit.fromJson(json['tempUnit']),
      measurementUnit: MeasurementUnit.fromJson(json['measurementUnit']),
    );
  }
}
