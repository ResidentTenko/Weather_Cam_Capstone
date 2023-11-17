// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter_application/constants/db_constant.dart';
import 'package:flutter_application/errors/auth_error.dart';
import 'package:google_sign_in/google_sign_in.dart';

// cloudfire store instance and a friebaseauth instance to communicate with firestore and firebase auth
//firebaseFirestore is an instance of FirebaseFirestore, which is used for Firestore operations
//firebaseAuth is an instance of FirebaseAuth from the fbAuth namespace, which is used for Firebase Authentication operations.

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  // Save Google signIn To fireStore
  // save users within collection with document UID
  Future<void> saveUserToFirestore({
    required String name,
    required String email,
    required String uid,
  }) async {
    await firebaseFirestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      // if a document with user's UID already exists, dont create a new one
    }, SetOptions(merge: true));
  }

  // the return type is Stream<fbAuth.User?>, which means it's a stream that emits events of type fbAuth.User?.
  // ? => indicates that the user object can be null
  // firebaseAuth.userChanges() is a method provided by the FirebaseAuth class.
  // It returns a stream that emits an event whenever the user's authentication status changes.
  // By using this getter, parts of your Flutter app can listen to this user stream and react to changes in the user's authentication status
  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  //Sign up is a future function that receives the name(to create a user collection in firestore), email and password

  Future<void> signup({
    required String name,
    required String email,
    required password,
  }) async {
    try {
      // if this functions succeds youll be logged in
      //This code is using the firebaseAuth object to create a new user account with an email and password.
      //The method createUserWithEmailAndPassword is asynchronous, so it returns a Futur
      //Once completed, the result is stored in the userCredential variable, which is of type UserCredential
      final fbAuth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //The userCredential object has a property user that represents the user who was just signed up.
      //This property can be null in some cases (for example, if the sign-up failed). However, the !  is used here to assert that user is not null.
      final signedInUser = userCredential.user!;

      // this start the operation with Firestore
      // usersRef refers to the refrence collection in Firestore where the user data is store db_constant
      //.doc(signedInUser.uid) is used to get a reference to a specific document in the users collection. The document's ID is the unique user ID (uid) of the signed-in user.
      //This is a way to store or retrieve data specific to the user who just signed up.
      await usersRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
      });
    }

    //his block catches exceptions of type fbAuth.FirebaseAuthException.
    //If such an exception occurs, it creates a new CostumerError with the details from the caught exception (e.code, e.message, and e.plugin).
    //The ! after e.message asserts that e.message is not null
    on fbAuth.FirebaseAuthException catch (e) {
      throw AuthError(code: e.code, message: e.message!, plugin: e.plugin);
    }
    // This block catches all other exceptions that weren't caught by the previous block.
    //If any other exception occurs, it creates a new CostumerError with a generic code "Exeption",
    //the message being the string representation of the caught exception (e.toString()), and a generic plugin value 'flutter/error/server_error'.
    catch (e) {
      throw AuthError(
          code: "Exeption",
          message: e.toString(),
          plugin: 'flutter/error/server_error');
    }
  }

  //This code uses the firebaseAuth object to sign in an existing user using their email and password.
  //The method signInWithEmailAndPassword is asynchronous, so it returns a Future. The await keyword is used to wait for this operation to complete before moving on.
  //If the sign-in is successful, the user will be authenticated. If not, this method will throw an error (like if the email/password combination is incorrect).

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fbAuth.FirebaseAuthException catch (e) {
      throw AuthError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw AuthError(
          code: "Exception",
          message: e.toString(),
          plugin: 'flutter/error/server_error');
    }
  }

  Future<void> signout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Sign out from Google
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        print('User signed out from Google');
      } else {
        print('User was not signed in with Google');
      }
      // Now sign out from Firebase
      await firebaseAuth.signOut();
      print('User signed out from Firebase');
    } catch (error) {
      print('Error signing out: $error');
      rethrow;
    }
  }
}
