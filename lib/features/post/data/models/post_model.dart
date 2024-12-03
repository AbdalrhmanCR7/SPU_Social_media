import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Post {
  final String id;
  final String userId;
  final String email;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime createdAt;
  final List<dynamic> likes;
  final List<dynamic> comments;

  Post({
    required this.id,
    required this.userId,
    required this.email,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
  });


  Post copyWith({String? imageUrl}) {
    return Post(id: id,
      userId: userId,
      email: email,
      userName: userName,
      text: text,
      imageUrl: imageUrl?? this.imageUrl,
      createdAt: createdAt,
    );
  }


  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'] ,
      email: json['email'] ,
      userName: json['userName'] ,
      text: json['text'] ,
      imageUrl: json['mediaUrl'] ,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes: List<dynamic>.from(json['likes'] ),
      comments: List<dynamic>.from(json['comments'] ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'userName': userName,
      'content': text,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'likes': likes,
      'comments': comments,
    };
  }
}
