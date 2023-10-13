import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/constants/db_constant.dart';
import 'package:flutter_application/errors/auth_error.dart';
import 'package:flutter_application/models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<User> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();
      if (userDoc.exists) {
        final currentUser = User.fromDoc(userDoc);
        return currentUser;
      }
      throw 'User not found';
    } on FirebaseException catch (e) {
      throw AuthError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw AuthError(
          code: "Exception",
          message: e.toString(),
          plugin: 'flutter/error/server_error');
    }
  }
}
