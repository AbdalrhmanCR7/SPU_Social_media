class User {
   final String uid;
   final String userName;

   final String profileImageUrl;

   User({
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

   Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as DateTime,
    );
  }
}
