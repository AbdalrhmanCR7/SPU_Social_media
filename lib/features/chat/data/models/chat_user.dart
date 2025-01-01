class UserChat {
  final String uid;
  final String userName;
  final String profileImageUrl;

  UserChat({
    required this.uid,
    required this.userName,
    required this.profileImageUrl,
  });
}

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}