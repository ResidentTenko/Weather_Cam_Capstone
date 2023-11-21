import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter_application/blocs/temp_settings/temp_settings_cubit.dart';
import 'package:flutter_application/blocs/weather/weather_bloc.dart';
import 'package:flutter_application/widgets/home_page_app_bar.dart';
import 'package:flutter_application/widgets/hourly_forecast_widget.dart';
import 'package:flutter_application/widgets/three_days_forecast.dart';
import 'package:flutter_application/widgets/weather_details.dart';
import 'package:flutter_application/widgets/weather_search_bar.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add the observer when the state is initialized
    WidgetsBinding.instance.addObserver(this);
    // run our startup function
    _appStartUp();
    //context.read<WeatherBloc>().add(FetchWeatherFromFBDatabaseEvent());
  }

  @override
  void dispose() {
    // Remove the observer when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // trigger app refresh logic if app moves from the background to the foreground
    if (state == AppLifecycleState.resumed) {
      _appRefresh();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _appStartUp() async {
    /**
     * Note to self: Do a fresh install when model changes. Or else your storage options (hydrated and firebase)
     * Will have a model that your app cannot extract data from properly
     */
    // Check if the WeatherStatus is loaded from Hydrated Bloc
    if (context.read<WeatherBloc>().state.status == WeatherStatus.loaded) {
      // update the weather at the current user location

      context.read<WeatherBloc>().add(FetchWeatherOnAppStartEvent());
    }
    // Else no local storage so fetch the weather information at the current location
    else {
      context.read<WeatherBloc>().add(FetchWeatherFromLocationEvent());
    }
  }

  Future<void> _appRefresh() async {
    // Check if the WeatherStatus is loaded
    if (context.read<WeatherBloc>().state.status == WeatherStatus.loaded) {
      // update the weather at the current page information
      context.read<WeatherBloc>().add(FetchWeatherOnAppRefreshEvent());
    }
    // else just refresh using the user's current location
    else {
      context.read<WeatherBloc>().add(FetchWeatherFromLocationEvent());
    }
  }

  double convertTemperature(double temp, TempUnit unit) {
    if (unit == TempUnit.celsius) {
      return (temp - 32) * 5 / 9;
    }
    return temp;
  }

  String convertMeasurement(double measurement, MeasurementUnit unit) {
    if (unit == MeasurementUnit.kilometers) {
      return ('${(measurement * 1.6).round()} km');
    }
    return '${measurement.round()} mi';
  }

  String adjustEpochForTimeZone(int epoch, String timeZone) {
    // Load time zone data
    tz.initializeTimeZones();

    // Convert UTC epoch to DateTime
    DateTime utcDateTime =
        DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);

    // Convert to the desired time zone
    tz.TZDateTime targetDateTime =
        tz.TZDateTime.from(utcDateTime, tz.getLocation(timeZone));

    // Format the result as a string
    String formattedTime = DateFormat.jm('en_US').format(targetDateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff3fa2fa),
                Color(0xFF7F8DA2),
                Color(0xFFFD5E53),
              ],
              stops: [
                0.33,
                0.66,
                0.99,
              ], // Adjust stops based on your preference
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state.status == WeatherStatus.loading ||
                  state.status == WeatherStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final tempUnit =
                    context.watch<TempSettingsCubit>().state.tempUnit;
                final measurementUnit =
                    context.watch<TempSettingsCubit>().state.measurementUnit;
                return RefreshIndicator(
                  onRefresh: _appRefresh,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: const HomePageAppBar(),
                    body: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text(
                                  state.weather.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'MavenPro',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                ),
                                child: Text(
                                  state.weather.region,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'MavenPro',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 148,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    child: Text(
                                      '${convertTemperature(state.weather.temp, tempUnit).round()}°',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
                                        fontFamily: 'MavenPro',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Baseline(
                                      baseline: 50.0,
                                      baselineType: TextBaseline.alphabetic,
                                      child: ClipRect(
                                        child: Text(
                                          state.weather.condition,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontFamily: 'MavenPro',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      '${DateFormat('E').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          state.weather.date * 1000,
                                          isUtc: true,
                                        ),
                                      )}:',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'MavenPro',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${convertTemperature(state.weather.minTemp, tempUnit).round()}° / ${convertTemperature(state.weather.maxTemp, tempUnit).round()}°',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'MavenPro',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Hourly Forecast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'MavenPro',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(149, 92, 209, 1),
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xff3fa2fa),
                                        blurRadius: 4.0,
                                        offset: Offset(-3.0, 3.0),
                                      ),
                                      BoxShadow(
                                        color: Color(0xff3fa2fa),
                                        blurRadius: 4.0,
                                        offset: Offset(1.5, 1.5),
                                      ),
                                    ],
                                  ),
                                  height: 130,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 71,
                                    itemBuilder: (context, index) {
                                      final hourly =
                                          state.weather.hourly[index];
                                      final lowerHourBound =
                                          state.weather.localTime - 3600;
                                      final upperHourBound =
                                          state.weather.localTime + (3600 * 24);
                                      if ((hourly.hourlyTime >
                                              lowerHourBound) &&
                                          (hourly.hourlyTime <
                                              upperHourBound)) {
                                        return HourlyForecast(
                                          hourlyTime: adjustEpochForTimeZone(
                                              hourly.hourlyTime,
                                              state.weather.timezone),
                                          hourlyIcon: hourly.hourlyIcon,
                                          hourlyTemp:
                                              '${convertTemperature(hourly.hourlyTemp, tempUnit).round()}°',
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Three Day Forecast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'MavenPro',
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: state.weather.forecast.length,
                                itemBuilder: (context, index) {
                                  final forecast =
                                      state.weather.forecast[index];
                                  return ThreeDaysForecast(
                                    forecastDay: forecast.forecastDate,
                                    forecastCondition:
                                        forecast.forecastConditon,
                                    forecastIcon: forecast.forecastIcon,
                                    forcastMinTemp:
                                        '${convertTemperature(forecast.forecastMinTemp, tempUnit).round()}°',
                                    forcastMaxTemp:
                                        '${convertTemperature(forecast.forecastMaxTemp, tempUnit).round()}°',
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Weather Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'MavenPro',
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon:
                                          Icons.device_thermostat_outlined,
                                      detailTitle: 'Feels like',
                                      detailValue:
                                          '${convertTemperature(state.weather.feelsLike, tempUnit).round()}°',
                                    ),
                                  ),
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon: Icons.wind_power_outlined,
                                      detailTitle:
                                          '${state.weather.windDirection} wind',
                                      detailValue: '${convertMeasurement(
                                        state.weather.windSpeed,
                                        measurementUnit,
                                      )}/h',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon: Icons.water_drop_outlined,
                                      detailTitle: 'Humidity',
                                      detailValue:
                                          '${state.weather.humidity.round()}%',
                                    ),
                                  ),
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon: Icons.wb_sunny_outlined,
                                      detailTitle: 'UV',
                                      detailValue:
                                          '${state.weather.uv.round()}',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon: Icons.remove_red_eye_outlined,
                                      detailTitle: 'Visibility',
                                      detailValue: convertMeasurement(
                                          state.weather.visibility,
                                          measurementUnit),
                                    ),
                                  ),
                                  Expanded(
                                    child: WeatherDetails(
                                      detailIcon: Icons.air_outlined,
                                      detailTitle: 'Pressure',
                                      detailValue:
                                          '${state.weather.pressure.round()} hPa',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          WeatherSearchBar(
                            onCitySelected: (selectedCity) {
                              context.read<WeatherBloc>().add(
                                    FetchWeatherEvent(
                                      inputQuery: selectedCity.url,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
