// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_capstone_weather/bloc/location/location_bloc.dart';
import 'package:my_capstone_weather/bloc/search/search_bloc.dart';
import 'package:my_capstone_weather/bloc/weather/weather_bloc.dart';
import 'package:my_capstone_weather/models/weather.dart';
import 'package:my_capstone_weather/pages/location_test.dart';
import 'package:my_capstone_weather/pages/search_test.dart';
import 'package:my_capstone_weather/pages/search_test_field.dart';
import 'package:my_capstone_weather/pages/weather_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load the env file so we can get the api key
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        )
      ],
      child: MaterialApp(
        title: 'WeatherCam App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WeatherTest(),
      ),
    );
  }
}
