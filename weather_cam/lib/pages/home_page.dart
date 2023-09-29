import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_capstone_weather/bloc/location/location_bloc.dart';
import 'package:my_capstone_weather/bloc/weather/weather_bloc.dart';
import 'package:my_capstone_weather/widgets/app_bar.dart';
import 'package:my_capstone_weather/widgets/three_days_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // read the context from Location Bloc gotten from Bloc Provider in main
    // call the add event of that Location Bloc
    context.read<LocationBloc>().add(FetchLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.status == LocationStatus.loading ||
              state.status == LocationStatus.initial) {
            return const Center(
              // Show loading indicator when status is not loaded or error
              child: CircularProgressIndicator(),
            );
          } else if (state.status == LocationStatus.error) {
            return Center(
              child: Text(
                  'Error: ${state.error.errMsg}'), // Adjust this as per your error handling
            );
          }
          // if location status is loaded correctly
          else {
            // load location variables
            final String query = '${state.latitude}, ${state.longitude}';
            // use the fetchweatherevent of my weatherbloc and feed it the position value
            context.read<WeatherBloc>().add(
                  FetchWeatherEvent(inputQuery: query),
                );
            return BlocBuilder<WeatherBloc, WeatherState>(
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
                    appBar: const CustomAppBar(),
                    body: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            state.weather.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'MavenPro'),
                          ),
                          const SizedBox(height: 15),
                          Image.network('https:${state.weather.icon}',
                              width: 180, height: 180, fit: BoxFit.fill),
                          Text(
                            state.weather.condition,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontFamily: 'MavenPro'),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.weather.temp}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontFamily: 'MavenPro',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Feels Like: ${state.weather.feelsLike}°',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Hubballi'),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Min: ${state.weather.minTemp}°',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'MavenPro'),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                'Max: ${state.weather.maxTemp}°',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'MavenPro'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${DateFormat('E').format(state.weather.lastUpdated)}                 ${DateFormat('MMMd').format(state.weather.lastUpdated)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Hubballi'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ThreeDaysForecast(
                                date: state.weather.forecast[0].forecastDay,
                                imageUrl:
                                    'https:${state.weather.forecast[0].icon}',
                                temperature:
                                    '${state.weather.forecast[0].maxTemp}°',
                              ),
                              ThreeDaysForecast(
                                date: state.weather.forecast[1].forecastDay,
                                imageUrl:
                                    'https:${state.weather.forecast[1].icon}',
                                temperature:
                                    '${state.weather.forecast[1].maxTemp}°',
                              ),
                              ThreeDaysForecast(
                                date: state.weather.forecast[2].forecastDay,
                                imageUrl:
                                    'https:${state.weather.forecast[2].icon}',
                                temperature:
                                    '${state.weather.forecast[2].maxTemp}°',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
