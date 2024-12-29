import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_user.dart';

class RemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب المستخدمين حسب الاسم
  Future<List<User>> fetchUsersByName(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: name)
        .where('userName', isLessThanOrEqualTo: '$name\uf8ff')
        .get();

    return snapshot.docs.map((doc) {
      final userData = doc.data();
      return User(
        uid: doc.id,
        userName: userData['userName'],

        profileImageUrl: userData['profileImageUrl'],
      );
    }).toList();
  }

  // جلب الرسائل
  Stream<List<Map<String, dynamic>>> getMessages(String currentUserId, String receiverId) {
    return _firestore
        .collection('messages')
        .snapshots()
        .map((snapshot)
    {
      return snapshot.docs
          .map((doc) => doc.data())
          .toList();

    });
  }



  // إرسال رسالة
  Future<void> sendMessage(
      String senderId, String receiverId, String message) async {
    await _firestore.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
