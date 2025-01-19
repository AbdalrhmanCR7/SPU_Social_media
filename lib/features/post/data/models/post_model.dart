
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
   final String userName;
  final String text;
  final List<String> imageUrls;
  final DateTime createdAt;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final String backgroundColor;

   final String profileImageUrl;

  Post({
      required this.profileImageUrl,
    required this.backgroundColor,
    required this.id,
    required this.userName,
    required this.text,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
    required this.imageUrls,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
     'profileImageUrl': profileImageUrl,
      'text': text,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'backgroundColor': backgroundColor,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userName: map['userName'] ,
      text: map['text'] as String,
      imageUrls: List<String>.from(map['imageUrls']),
        createdAt: (map['createdAt'] as Timestamp).toDate(),

      likes: List<dynamic>.from(map['likes']),
      comments: List<dynamic>.from(map['comments']),
      backgroundColor: map['backgroundColor'] ,
      profileImageUrl: map['profileImageUrl'],
    );
  }
}

class UserPost {
  final String uid;
  final String userName;
  final String profileImageUrl;

  UserPost({
    required this.uid,
    required this.userName,
    required this.profileImageUrl,
  });
}
