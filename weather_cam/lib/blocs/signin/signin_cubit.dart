import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/auth_error.dart';
import 'package:flutter_application/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  SigninCubit({required this.authRepository}) : super(SigninState.initial());

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signinStatus: SigninStatus.submitting));

    try {
      await authRepository.signin(email: email, password: password);
      emit(state.copyWith(signinStatus: SigninStatus.success));
    } on AuthError catch (e) {
      emit(
        state.copyWith(
          signinStatus: SigninStatus.error,
          error: e,
        ),
      );
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signinStatus: SigninStatus.submitting));

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        emit(state.copyWith(signinStatus: SigninStatus.success));
      } else {
        emit(state.copyWith(
            signinStatus: SigninStatus.error,
            error: const AuthError(message: 'Google Sign-In cancelled')));
      }
    } catch (error) {
      print(error);
      emit(state.copyWith(
          signinStatus: SigninStatus.error,
          error: const AuthError(message: 'Google Sign-In failed')));
    }
  }
}
