// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_capstone_weather/bloc/location/location_bloc.dart';
import 'package:my_capstone_weather/bloc/weather/weather_bloc.dart';
import 'package:my_capstone_weather/services/weather_api_services.dart';

class WeatherTest extends StatefulWidget {
  const WeatherTest({super.key});

  @override
  State<WeatherTest> createState() => _WeatherTestState();
}

class _WeatherTestState extends State<WeatherTest> {
  @override
  void initState() {
    super.initState();
    //_testWeather();
    // read the context from Location Bloc gottem from Bloc Provider in main
    // call the add event of that Location Bloc
    context.read<LocationBloc>().add(FetchLocationEvent());
  }

  _testWeather() {
    WeatherApiServices().getWeather('London');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      // when we use weatherbloc in the bloc builder, we will listen to location bloc as well using bloc listener
      body: BlocBuilder<LocationBloc, LocationState>(
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
          } else {
            final String query = '${state.latitude}, ${state.longitude}';
            print('FetchWeather: $query');
            context
                .read<WeatherBloc>()
                .add(FetchWeatherEvent(inputQuery: query));
            return BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state.status == WeatherStatus.loading ||
                    state.status == WeatherStatus.initial) {
                  return const Center(
                    // Show loading indicator when status is not loaded or error
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Country: ${state.weather.country}',
                          style: const TextStyle(
                            fontSize: 24, // Adjust the font size as needed
                            color:
                                Colors.black, // Adjust the text color as needed
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          'Region: ${state.weather.name}',
                          style: const TextStyle(
                            fontSize: 24, // Adjust the font size as needed
                            color:
                                Colors.black, // Adjust the text color as needed
                          ),
                        ),
                        Text(
                          'Region: ${state.weather.forecast[0].forecastDay}',
                          style: const TextStyle(
                            fontSize: 24, // Adjust the font size as needed
                            color:
                                Colors.black, // Adjust the text color as needed
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
