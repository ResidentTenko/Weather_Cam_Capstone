// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_application/pages/home_page.dart';
import 'package:flutter_application/pages/signin_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/';

  const SplashPage({Key? key}) : super(key: key);

  //BlocConsumer is a widget from the flutter_bloc package that combines the functionalities of BlocBuilder and BlocListener.
  //It listens to state changes and rebuilds the UI accordingly.
  //It's set up to work with AuthBloc and its states of type AuthState

  @override
  Widget build(BuildContext context) {
    //The listener reacts to state changes without rebuilding the UI.
    //If the user's authStatus is unauthenticated, it navigates to the SigninPage.
    //If the user's authStatus is authenticated, it navigates to the HomePage
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.restorablePushNamedAndRemoveUntil(
              context, SigninPage.routeName, (route) {
            print('route.settings.name: ${route.settings.name}');
            print('ModalRoute: ${ModalRoute.of(context)!.settings.name}');
            return route.settings.name == ModalRoute.of(context)!.settings.name
                ? true
                : false;
          });
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushNamed(context, HomePage.routeName);
        }
      },
      //The builder rebuilds the UI based on state changes.
      //Regardless of the state, it currently shows a loading spinner (CircularProgressIndicator) centered on the screen.
      // This is typical for a splash screen, indicating that some background processing or checks are happening.
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
