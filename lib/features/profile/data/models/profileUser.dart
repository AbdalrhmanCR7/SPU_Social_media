

import '../../../register/data/entities/user.dart';

class ProfileUser extends Userinfo {
  final String? bio;
  final String? profileImageUrl;

  const ProfileUser({
    this.bio,
    this.profileImageUrl,
    required super.uid,
    required super.id,
    required super.userName,
    required super.email,
    required super.date,
  });

  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      uid: uid,
      id: id,
      userName: userName,
      email: email,
      date: date,
    );
  }
}


