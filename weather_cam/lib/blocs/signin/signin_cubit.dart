import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application/errors/auth_error.dart';
import 'package:flutter_application/repositories/auth_repository.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  final GoogleSignIn googleSignIn;
  final fbAuth.FirebaseAuth firebaseAuth;

  SigninCubit({
    required this.authRepository,
    required this.googleSignIn,
    required this.firebaseAuth,
  }) : super(SigninState.initial());

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

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(signinStatus: SigninStatus.submitting));

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // User is logged in
        emit(state.copyWith(signinStatus: SigninStatus.success));
      } else {
        // User cancelled the login
        emit(state.copyWith(
            signinStatus: SigninStatus.error,
            error: const AuthError(message: 'Facebook Sign-In cancelled')));
      }
    } catch (error) {
      print(error);
      emit(state.copyWith(
          signinStatus: SigninStatus.error,
          error: const AuthError(message: 'Facebook Sign-In failed')));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signinStatus: SigninStatus.submitting));

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Retrive auth details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // authenticate the user with firebase
        final credential = fbAuth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google user credentials/Authenticate usser in Firebase
        await firebaseAuth.signInWithCredential(credential);

        // Get the signed-in user
        final fbAuth.User? firebaseUser =
            firebaseAuth.currentUser; // retrieve current user
        if (firebaseUser != null) {
          // Save the user data in Firestore
          // saveusertoFirestore
          await authRepository.saveUserToFirestore(
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            uid: firebaseUser.uid,
          );
        }

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
