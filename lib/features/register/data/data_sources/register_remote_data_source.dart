import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user.dart' as user_entity;

class RegisterRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register({
    required String email,
    required String password,
    required String userName,
  }) async {
    final UserCredential firebaseUser =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final QuerySnapshot<Map<String, dynamic>> userCollection =
        await _firestore.collection('users').orderBy("date").get();
    final int lastUser =
        userCollection.docs.isEmpty ? 0 : userCollection.docs.last['id'];
    final user_entity.Userinfo user = user_entity.Userinfo(
      id: lastUser + 1,
      email: email,
      userName: userName,
      uid: firebaseUser.user?.uid,
      date: Timestamp.now(),
    );
    await _firestore.collection('users').add(user.toMap());
  }
}
