// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

//This is an abstract class, meaning you can't instantiate it directly. Instead, it serves as a base for other event classes.
//It extends Equatable, which helps in comparing different instances of the class.

abstract class AuthEvent extends Equatable {
  const AuthEvent();

//The props list is used by Equatable to determine if two instances are equal. By default, it's an empty list for the base AuthEvent
  @override
  List<Object?> get props => [];
}

//This class represents an event where the authentication state has changed.
//It has a property user which can be null. This property likely represents the authenticated user or null if no user is authenticated.
class AuthStateChangedEvent extends AuthEvent {
  final fbAuth.User? user;
  const AuthStateChangedEvent({
    this.user,
  });

  //The props list contains the user, which means two AuthStateChangedEvent instances are considered equal if their user properties are the same.
  @override
  List<Object?> get props => [user];
}

//This class represents an event where a sign-out action has been requested.
//It doesn't have any additional properties or methods, so it's just a simple event to signal the BLoC that the user wants to sign out.
class SignoutRequestedEvent extends AuthEvent {}
