import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserChat>> fetchUsersByName(String name) {
    final lowerCaseName = name.toLowerCase();
    return FirebaseFirestore.instance
        .collection('users')
        .where('userNameLower', isGreaterThanOrEqualTo: lowerCaseName)
        .where('userNameLower', isLessThanOrEqualTo: '$lowerCaseName\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final userData = doc.data();
        return UserChat(
          uid: doc.id,
          userName: userData['userName'] ?? '',
          profileImageUrl: userData['profileImageUrl'] ?? '',
        );
      }).toList();
    });
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.reversed.map((doc) {
        final data = doc.data();
        return Message(
          senderId: data['senderId'] ?? '',
          receiverId: data['receiverId'] ?? '',
          message: data['message'] ?? '',
          timestamp: data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();
    });
  }

  Future<void> sendMessage(
      String chatId, String receiverId, String message) async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    if (currentUser != null) {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUser,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore.collection("chats").doc(chatId).set({
        'users': [currentUser, receiverId],
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      throw Exception('Current User is Null');
    }
  }

  Future<String?> getChatRoom(String receiverId) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final chatQuery = await _firestore
          .collection('chats')
          .where('users', arrayContains: currentUser.uid)
          .get();

      final chats = chatQuery.docs
          .where((chat) => chat['users'].contains(receiverId))
          .toList();

      if (chats.isNotEmpty) {
        return chats.first.id;
      }
    }
    return null;
  }

  Future<String> createChatRoom(String receiverId) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final String currentUserName = currentUserDoc.data()?['userName'];

      final receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      final String receiverName = receiverDoc.data()?['userName'];

      final chatRoom = await _firestore.collection('chats').add({
        'users': [currentUser.uid, receiverId],
        'userNames': [currentUserName, receiverName],
        'lastMessage': '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return chatRoom.id;
    }
    throw Exception('Current User is Null');
  }

  Stream<List<UserChatWithMessage>> viewUsers() {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    if (currentUser != null) {
      return _firestore
          .collection('chats')
          .snapshots()
          .asyncMap((snapshot) async {
        List<UserChatWithMessage> userChats = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();

          // الشرط: التحقق من وجود chatRoom.id فقط
          if (doc.id.isNotEmpty) {
            final List users = data['users'] ?? [];
            if (users.isNotEmpty) {
              final userId = users.firstWhere((id) => id != currentUser);
              final userDoc =
                  await _firestore.collection('users').doc(userId).get();
              final userData = userDoc.data();
              if (userData != null) {
                userChats.add(UserChatWithMessage(
                  uid: userId,
                  userName: userData['userName'] ?? '',
                  profileImageUrl: userData['profileImageUrl'] ?? '',
                  lastMessage: data['lastMessage'] ?? '',
                  timestamp: (data['timestamp'] as Timestamp).toDate(),
                ));
              }
            }
          }
        }

        userChats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return userChats;
      });
    } else {
      throw Exception('Current User is Null');
    }
  }
}
