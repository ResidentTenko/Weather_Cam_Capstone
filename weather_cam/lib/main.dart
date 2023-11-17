// ignore_for_file: library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_application/blocs/profile/profile_cubit.dart';
import 'package:flutter_application/blocs/search/search_bloc.dart';
import 'package:flutter_application/blocs/signin/signin_cubit.dart';
import 'package:flutter_application/blocs/signup/signup_cubit.dart';
import 'package:flutter_application/blocs/temp_settings/temp_settings_cubit.dart';
import 'package:flutter_application/blocs/weather/weather_bloc.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:flutter_application/pages/signin_page.dart';
import 'package:flutter_application/pages/signup_page.dart';
import 'package:flutter_application/pages/splash_page.dart';
import 'package:flutter_application/repositories/auth_repository.dart';
import 'package:flutter_application/repositories/profile_repository.dart';
import 'package:flutter_application/repositories/weather_respository.dart';
import 'package:flutter_application/services/api_weather_services.dart';
import 'package:flutter_application/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  // the hydrated bloc storage.build function calls native code so we need to call ensure initialized
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await dotenv.load(fileName: '.env');
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //this widget provides multiple repositories to its descendants.
    // In this case, it provides an AuthRepository which is initialized with instances of FirebaseFirestore and FirebaseAuth
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider<ApiWeatherRepository>(
          create: (context) => ApiWeatherRepository(
            apiWeatherServices: ApiWeatherServices(
              httpClient: Client(),
            ),
            firebaseAuth: context.read<AuthRepository>().firebaseAuth,
            firebaseFirestore: context.read<AuthRepository>().firebaseFirestore,
          ),
        ),
      ],
      //This widget provides multiple BLoCs to its descendants.
      //Here, it provides an AuthBloc which is initialized with the AuthRepository from the context.
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
              googleSignIn: GoogleSignIn(),
              firebaseAuth: fbAuth.FirebaseAuth.instance,
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              apiWeatherRepository: context.read<ApiWeatherRepository>(),
              locationServices: LocationServices(),
            ),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              apiWeatherServices:
                  context.read<ApiWeatherRepository>().apiWeatherServices,
            ),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'FireBase Auth',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashPage(),
          routes: {
            SignupPage.routeName: (context) => const SignupPage(),
            SigninPage.routeName: (context) => const SigninPage(),
            HomePage.routeName: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
