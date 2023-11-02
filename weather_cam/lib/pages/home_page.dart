import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/temp_settings/temp_settings_cubit.dart';
import 'package:flutter_application/blocs/weather/weather_bloc.dart';
import 'package:flutter_application/widgets/liveview_app_bar.dart';
import 'package:flutter_application/widgets/three_days_forecast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchWeatherFromLocationEvent());
  }

  double convertTemperature(double temp, TempUnit unit) {
    if (unit == TempUnit.celsius) {
      return (temp - 32) * 5 / 9;
    }
    return temp;
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
              colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.3, 0.85],
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
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: const LiveViewAppBar(),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            state.weather.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'MavenPro',
                            ),
                          ),
                        ),
                        const SizedBox(height: 180),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
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
                            Baseline(
                              baseline: 50.0,
                              baselineType: TextBaseline.alphabetic,
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
                                      state.weather.date * 1000),
                                )}:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'MavenPro',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
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
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.weather.forecast.length,
                          itemBuilder: (context, index) {
                            final forecast = state.weather.forecast[index];
                            return ThreeDaysForecast(
                              day: forecast.forecastDate,
                              imageUrl: 'https:${forecast.icon}',
                              forcastMinTemp:
                                  '${convertTemperature(forecast.minTemp, tempUnit).round()}°',
                              forcastMaxTemp:
                                  '${convertTemperature(forecast.maxTemp, tempUnit).round()}°',
                            );
                          },
                        ),
                      ],
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
