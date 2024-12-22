import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
   final UserCredential user= await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
   return user.user!.uid;
  }
}
