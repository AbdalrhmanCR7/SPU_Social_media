import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../register/data/entities/user.dart';
import '../models/chat_user.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> sendMessage(Message message) async {
    await _firebaseFirestore.collection('messages').add(message.toMap());
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _firebaseFirestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

  Future<List<Userinfo>> searchUsers(String query) async {
    final snapshot = await _firebaseFirestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '${query}z')
        .get();
    return snapshot.docs.map((doc) => Userinfo.fromMap(doc.data())).toList();
  }

  Future<Userinfo?> getUserById(String userId) async {
    final doc = await _firebaseFirestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return Userinfo.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
