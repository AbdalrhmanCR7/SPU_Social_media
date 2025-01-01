abstract class ChatEvent {}

class FetchUsersEvent extends ChatEvent {
  final String name;
  FetchUsersEvent({ required this.name});
}

class FetchMessagesEvent extends ChatEvent {
  final String chatId;
  FetchMessagesEvent({required this.chatId});
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String receiverId;
  final String message;
  SendMessageEvent({required this.chatId, required this.receiverId, required this.message});
}

class CreateChatRoomEvent extends ChatEvent {
  final String receiverId;
  CreateChatRoomEvent({required this.receiverId});
}

class FetchChatRoomEvent extends ChatEvent {
  final String receiverId;
  FetchChatRoomEvent({required this.receiverId});
}
