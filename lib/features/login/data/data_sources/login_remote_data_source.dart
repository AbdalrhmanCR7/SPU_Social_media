import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
