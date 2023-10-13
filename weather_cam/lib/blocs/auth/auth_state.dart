// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

//his enum defines three possible authentication statuses: unknown, authenticated, and unauthenticated
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

//The AuthState class extends Equatable, which makes it easier to compare instances of the class.
//It has two properties: authStatus (which uses the AuthStatus enum) and user (which can be null).
class AuthState extends Equatable {
  final AuthStatus authStatus;
  final fbAuth.User? user;

  //This is the main constructor for the AuthState class. The authStatus is required, while user is optional.
  const AuthState({
    required this.authStatus,
    this.user,
  });

  //factory Keyword: This keyword indicates that this is a factory constructor. It means that this constructor doesn't always have to create a new instance of AuthState.
  //In this specific case, it does create a new instance, but in other scenarios, it might return a cached instance or an instance of a subtype.
  // It's a named constructor because it has a name (unknown) after the class name (AuthState).
  factory AuthState.unknown() {
    return const AuthState(authStatus: AuthStatus.unknown);
  }

  //This override is part of the Equatable package. It defines which properties should be used to determine if two instances are equal.
  @override
  List<Object?> get props => [authStatus, user];

  //This method allows for creating a new AuthState instance by copying the current state and optionally overriding some properties.
  // It's a common pattern in immutable state management.
  AuthState copyWith({
    AuthStatus? authStatus,
    fbAuth.User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }

//Another override from Equatable.
// When stringify is true, the toString method will output a more readable string format, which can be helpful for debugging.
  @override
  bool get stringify => true;
}
