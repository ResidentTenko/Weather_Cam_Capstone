// ignore_for_file: library_prefixes

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
//The part directive is used to include the auth_event.dart and auth_state.dart files,
//which likely contain the event and state definitions for this BLoC
part 'auth_event.dart';
part 'auth_state.dart';
//This class is a BLoC (Business Logic Component) that handles authentication logic using the flutter_bloc package.
//It listens to authentication events, processes them, and produces corresponding authentication states.

//The AuthBloc class extends the generic Bloc class, specifying AuthEvent as the event type and AuthState as the state type.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //authSubsription: A stream subscription that listens to user changes from the authRepository
  //authRepository: An instance of AuthReposirtor that  interacts with Firebase Authentication.
  late final StreamSubscription authSubsription;
  final AuthRepository authRepository;

  //The constructor initializes the BLoC with an authRepository and sets the initial state to AuthState.unknown()
  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    //The BLoC subscribes to the user stream from the authRepository.
    // Whenever there's a change in the user's authentication status, it adds an AuthStateChangedEvent to the BLoC
    authSubsription = authRepository.user.listen((fbAuth.User? user) {
      add(AuthStateChangedEvent(user: user));
    });

    //This block defines how the BLoC should handle the AuthStateChangedEvent.
    //If the user is not null, it means the user is authenticated. Otherwise, the user is unauthenticated.
    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: event.user,
          ),
        );
      } else {
        emit(
            state.copyWith(authStatus: AuthStatus.unauthenticated, user: null));
      }
    });

    // if the event is signout request event
    //This block defines how the BLoC should handle the SignoutRequestedEvent.
    //When this event is received, the BLoC calls the signout method on the authRepository to log the user out.
    on<SignoutRequestedEvent>((event, emit) async {
      await authRepository.signout();
    });
  }
}
