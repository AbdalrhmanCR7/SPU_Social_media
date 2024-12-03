import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/profileUser.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);

  Future<void> updateProfile(ProfileUser updatedProfile);
}

class NewProfileRemoteDataSource implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      if (userData != null) {
        return ProfileUser(
            bio: userData['bio'],
            profileImageUrl: userData['profileImageUrl'].toString(),
            uid: uid,
            id: userData['id'],
            userName: userData['userName'],
            email: userData['email'],
            date: userData['date']);
      }
    }
    return null;
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    await firebaseFirestore.collection('users').doc(updatedProfile.uid).update({
      'bio': updatedProfile.bio,
      'profileImageUrl': updatedProfile.profileImageUrl,
    });
  }
}
