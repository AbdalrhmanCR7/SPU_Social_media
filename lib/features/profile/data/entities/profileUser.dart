import '../../../register/data/entities/user.dart';
class ProfileUser extends Userinfo {
  final String bio;
  final String profileImageUrl;

  const ProfileUser({
    required this.bio,
    required this.profileImageUrl,
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
        date: date);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'email': email,
      'userName': userName,
      'date': date,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory ProfileUser.fromJson(Map<String,dynamic>json){
    return ProfileUser(
      uid: json['uid'],
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
       bio: json['bio'] ?? '',
      date: json['date'],
      profileImageUrl: json['profileImageUrl'] ?? '',


    );

  }
}
