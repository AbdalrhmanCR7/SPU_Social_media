abstract class ChatEvent {}

class FetchUsersEvent extends ChatEvent {
  final String name;

  FetchUsersEvent({required this.name});
}

class FetchMessagesEvent extends ChatEvent {
  final String currentUserId;
  final String receiverId;

  FetchMessagesEvent({required this.currentUserId, required this.receiverId});
}

class SendMessageEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;

  SendMessageEvent({required this.senderId, required this.receiverId, required this.message});
}
