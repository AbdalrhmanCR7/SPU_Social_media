import '../data/models/chat_user.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatUsersLoaded extends ChatState {
  final  User user ;

  ChatUsersLoaded({required this.user});
}

class ChatMessagesLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;

  ChatMessagesLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}

class ChatMessagesSent extends ChatState {}
