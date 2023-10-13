import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/auth_error.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final AuthError error;

  const SignupState({
    required this.signupStatus,
    required this.error,
  });

  factory SignupState.initial() {
    return const SignupState(
        signupStatus: SignupStatus.initial, error: AuthError());
  }

  SignupState copyWith({
    SignupStatus? signupStatus,
    AuthError? error,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [signupStatus, error];
}
