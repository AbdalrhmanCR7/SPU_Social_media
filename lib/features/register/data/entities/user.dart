import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Userinfo extends Equatable {
  final int id;
  final String? uid;
  final String userName;
  final String email;
  final Timestamp date;

  const Userinfo({
    required this.id,
    required this.uid,
    required this.userName,
    required this.email,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        uid,
        userName,
        email,
        date,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'userName': userName,
      'email': email,
      'date': date,
    };
  }

  factory Userinfo.fromMap(Map<String, dynamic> map) {
    return Userinfo(
      id: map['id'] as int,
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      date: map['date'] as Timestamp,
    );
  }
}
