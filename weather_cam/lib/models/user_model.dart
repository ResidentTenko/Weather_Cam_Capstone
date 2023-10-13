// creating the user model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory constructor User.fromDoc
  //This is a factory constructor named fromDoc. Factory constructors in Dart can return an instance of a class,
  //it's being used to create a User object from a Firestore document.
  factory User.fromDoc(DocumentSnapshot userDoc) {
    //calling the data() method on the userDoc (which is of type DocumentSnapshot).
    //This method returns the data of the Firestore document as a map. The as Map<String, dynamic>? part is a typecast, ensuring that the returned data is treated as a map with string keys and dynamic values.
    //The ? indicates that this map can be null.
    final userData = userDoc.data() as Map<String, dynamic>?;

    //userDoc.id: This gets the document's ID from Firestore (every document in Firestore has a unique ID).
    //userData!['name']: This fetches the 'name' value from the userData map. The ! is the null assertion operator, which tells Dart that userData is not null at this point.
    //userData['email']: Similarly, this fetches the 'email' value from the userData map.
    return User(
        id: userDoc.id, name: userData!['name'], email: userData['email']);
  }

  //User.initialUser is a virtual user that does not exist in the firestore
  // when the app is started the data is rare and user related info becomes null - because the user must be cleared
  factory User.initialUser() {
    return const User(id: '', name: '', email: '');
  }
  //This is an override of the props getter from the Equatable class.
  // Equatable is a package that helps with comparing instances of objects based on their properties rather than their references.
  // By providing a list of properties in the props getter, you're telling Equatable which properties of the User class should be considered when determining if two User objects are equal.
  // In this case, two User objects are considered equal if their id, name, and email are all the same.
  @override
  List<Object> get props => [id, name, email];

  //toString method, which is a method every Dart object has.
  // This method returns a string representation of the object.
  //By providing a custom implementation, you're specifying how the user should be presented
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
