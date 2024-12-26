import 'package:equatable/equatable.dart';

import '../data/models/chat_user.dart';


sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final Message message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SearchUsersEvent extends ChatEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}
