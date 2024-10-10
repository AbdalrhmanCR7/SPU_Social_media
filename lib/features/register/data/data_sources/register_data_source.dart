import 'package:firebase_auth/firebase_auth.dart';

class RegisterDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
