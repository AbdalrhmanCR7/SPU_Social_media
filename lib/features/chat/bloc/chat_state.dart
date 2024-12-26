


import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/chat_user.dart';


sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
