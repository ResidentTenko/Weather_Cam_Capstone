import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_capstone_weather/bloc/search/search_bloc.dart';
import 'package:my_capstone_weather/bloc/weather/weather_bloc.dart';
import 'package:my_capstone_weather/pages/home_page.dart';
import 'package:my_capstone_weather/repositories/weather_respository.dart';
import 'package:my_capstone_weather/services/api_weather_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiWeatherRepository>(
          create: (context) => ApiWeatherRepository(
            apiWeatherServices: ApiWeatherServices(
              httpClient: http.Client(),
            ),
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              apiWeatherRepository: context.read<ApiWeatherRepository>(),
            ),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              apiWeatherServices:
                  context.read<ApiWeatherRepository>().apiWeatherServices,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
          home: const Placeholder(),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
