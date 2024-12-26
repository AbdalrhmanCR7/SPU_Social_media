import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart'; // استخدام مكتبة dartz
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/chat_user.dart';

import '../data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(MessageSending());
      final result = await _chatRepository.sendMessage(event.message);
      result.fold(
            (failure) => emit(ChatError('Failed to send message: ${failure.message}')),
            (_) => emit(MessageSent()),
      );
    });

    on<LoadMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      await emit.forEach<List<Message>>(
        _chatRepository.getMessages(event.chatId),
        onData: (messages) => MessagesLoaded(messages),
        onError: (error, stackTrace) => ChatError('Failed to load messages: $error'),
      );
    });

    on<SearchUsersEvent>((event, emit) async {
      emit(UsersLoading());
      final result = await _chatRepository.searchUsers(event.query);
      result.fold(
            (failure) => emit(ChatError('Failed to search users: ${failure.message}')),
            (users) => emit(UsersLoaded(users.cast<User>())),
      );
    });
  }
}
