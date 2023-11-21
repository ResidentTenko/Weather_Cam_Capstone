import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'temp_settings_state.dart';

class TempSettingsCubit extends Cubit<TempSettingsState> with HydratedMixin {
  TempSettingsCubit() : super(TempSettingsState.initial());
  void toggleTempUnit() {
    emit(
      state.copyWith(
        tempUnit: state.tempUnit == TempUnit.celsius
            ? TempUnit.fahrenheit
            : TempUnit.celsius,
      ),
    );
    print('tempUnit: $state');
  }

  void toggleMeasurementUnit() {
    emit(
      state.copyWith(
        measurementUnit: state.measurementUnit == MeasurementUnit.kilometers
            ? MeasurementUnit.miles
            : MeasurementUnit.kilometers,
      ),
    );
    print('measurementUnit: $state');
  }

  @override
  TempSettingsState fromJson(Map<String, dynamic> json) {
    return TempSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(TempSettingsState state) {
    return state.toJson();
  }
}
