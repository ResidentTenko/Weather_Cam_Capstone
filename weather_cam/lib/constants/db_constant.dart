import 'package:cloud_firestore/cloud_firestore.dart';

// Store a refernce to the user collecction, to implement authentication in firebase
// the reason is common to create and save seperate user collection for additional user who sign to firebase

final usersRef = FirebaseFirestore.instance.collection('users');
final weatherRef = FirebaseFirestore.instance.collection('weather');
final forecastRef = FirebaseFirestore.instance.collection('forecast');
final hourlyRef = FirebaseFirestore.instance.collection('hourly');
