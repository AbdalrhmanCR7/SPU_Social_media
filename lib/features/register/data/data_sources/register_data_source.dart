import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/app_extensions.dart';

class RegisterDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register({
    required String email,
    required String password,
    required String userName,
  }) async {
    final UserCredential user =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userCollection = await _firestore.collection('users').get();
    if (userCollection.docs.isEmpty) {
      _firestore.collection('users').doc('1'.addZerosToString()).set({
        "id": 1,
        "userName": userName,
        "email": email,
      });
    } else {
      _firestore
          .collection('users')
          .doc((userCollection.docs.last["id"] + 1)
              .toString()
              .addZerosToString())
          .set({
        "id": userCollection.docs.last["id"] + 1,
        "userName": userName,
        "email": email,
      });
    }
  }
}
