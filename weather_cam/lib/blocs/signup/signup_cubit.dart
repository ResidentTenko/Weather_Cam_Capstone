import 'package:bloc/bloc.dart';
import 'package:flutter_application/errors/auth_error.dart';
import 'package:flutter_application/repositories/auth_repository.dart';
import 'signup_state.dart'; // Ensure this path is correct

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit({
    required this.authRepository,
  }) : super(SignupState.initial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signupStatus: SignupStatus.submitting));
    try {
      await authRepository.signup(
        name: name,
        email: email,
        password: password,
      );
      emit(state.copyWith(signupStatus: SignupStatus.success));
    } on AuthError catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.error, error: e));
    }
  }
}
