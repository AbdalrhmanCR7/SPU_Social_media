import '../data/models/chat_user.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatUsersLoaded extends ChatState {
  final List<UserChat> users;

  ChatUsersLoaded({required this.users});
}

class ChatMessagesLoaded extends ChatState {
  final List<Message> messages;

  ChatMessagesLoaded({required this.messages});
}

class ChatMessagesSent extends ChatState {}

class ChatRoomCreated extends ChatState {
  final String chatRoomId;

  ChatRoomCreated({required this.chatRoomId});
}

class ChatRoomLoaded extends ChatState {
  final String chatRoomId;

  ChatRoomLoaded({required this.chatRoomId});
}

class ViewUsersLoaded extends ChatState {
  final List<UserChatWithMessage> users;

  ViewUsersLoaded({required this.users});
}

class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}
