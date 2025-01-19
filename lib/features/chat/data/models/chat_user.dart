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
  final String messageId;
  final DateTime timestamp;


  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageId,
    required this.timestamp,

  });

}


class UserChatWithMessage {
  final String uid;
  final String userName;
  final String profileImageUrl;
  final String lastMessage;
  final DateTime timestamp;

  UserChatWithMessage({
    required this.uid,
    required this.userName,
    required this.profileImageUrl,
    required this.lastMessage,
    required this.timestamp,
  });
}





