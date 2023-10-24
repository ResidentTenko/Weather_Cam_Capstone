import 'package:flutter/material.dart';
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

    // Check if the storage is empty
    // final isStorageEmpty = await HydratedBlocStorage.getInstance().isEmpty;

    // read the context from Location Bloc gotten from Bloc Provider in main
    // call the add event of that Location Bloc
    context.read<WeatherBloc>().add(FetchWeatherFromLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff955cd1),
            Color(
              0xff3fa2fa,
            ),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [
            0.3,
            0.85,
          ],
        ),
      ),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.status == WeatherStatus.loading ||
              state.status == WeatherStatus.initial) {
            return const Center(
              // Show loading indicator when status is not loaded or error
              child: CircularProgressIndicator(),
            );
          }
          // else if weather status loads successfully build the app using the widgets below
          else {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const LiveViewAppBar(),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Text(
                        state.weather.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontFamily: 'MavenPro',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 180,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            '${state.weather.temp.round()}°',
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
                            '${state.weather.minTemp.round()}° / ${state.weather.maxTemp.round()}°',
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
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.weather.forecast.length,
                      itemBuilder: (context, index) {
                        final forecast = state.weather.forecast[index];
                        
                        return ThreeDaysForecast(
                          day: forecast.forecastDate,
                          imageUrl: 'https:${forecast.icon}',
                          forcastMinTemp: '${forecast.minTemp.round()}°',
                          forcastMaxTemp: '${forecast.maxTemp.round()}°'
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}