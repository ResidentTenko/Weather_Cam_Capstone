// ignore_for_file: library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart';
// we alias to prevent a conflict when using the user model defined by us and the user model provided by firebase at the same time
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:my_capstone_weather/errors/auth_error.dart';

// To signup, signin, and signout of firebase you need to call functions provided by firebase

class AuthRepository {
  // get a firebase auth instance and a firestore instance to communicate with firestore and firebase through the constructor
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  // create a getter function so we can access the fireabase UserChanges stream function easily
  // User changes is a stream so declare our getter as a user stream
  // we can listen to changes in the stream
  // for example: when logged out, user will become null
  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  // future void type async function.
  // we get name, email, and password from the input form
  // the signup function only needs email and password but we ask for name so we can create a firestore collection for storage functionality
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // call the firebase function createUserithEmailandPassword
      // if this function succeeds you will be logged in at the same time

      final fbAuth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // btw value of the user getter changes at this point

      // signed in user is not null since signup was successful - therefore use the bang operator
      final signedInUser = userCredential.user!;

      // now we create a document with signed in user's id as the Document ID/Document reference
      // remember if the docid doesn't exist, the doc is created and the values are set then and there
      await FirebaseFirestore.instance
          .collection('users')
          .doc(signedInUser.uid)
          .set(
        {
          'name': name,
          'email': email,
          'profileImage': 'https://picsum.photos/300',
          'point': 0,
          'rank': 'bronze',
        },
      );
    }
    // separate firebase auth error from general error and handle it seperately
    // if an error occurs, a firebase auth exception object is received. this object has three properites
    // we handle the error and properties using our custom error
    on fbAuth.FirebaseAuthException catch (e) {
      // throwing an error means the handling of the error is left up to the caller
      // the caller gets a CustomError object and decides what do do with it
      throw AuthError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    }
    // this is where we handle general errors
    catch (e) {
      throw AuthError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  // the signin function contains the same logic as above
  // but we do not need to create a user doc in firestore since it already exists on signup
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
      throw AuthError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw AuthError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  // call the signout function of the firebase auth instance
  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
