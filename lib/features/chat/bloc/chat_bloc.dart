import 'package:bloc/bloc.dart';

import '../data/data_sources/chat_remote_data_source.dart';
import '../data/models/chat_user.dart';
import '../data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserRepository _userRepository;

  UserRepository get chatRepository => UserRepository(ChatRemoteDataSource());

  ChatBloc(this._userRepository) : super(ChatInitial()) {
    on<FetchChatRoomEvent>((event, emit) async {
      final chatRoomId = await _userRepository.getChatRoom(event.receiverId);
      if (chatRoomId != null) {
        emit(ChatRoomLoaded(chatRoomId: chatRoomId));
      } else {
        final newChatRoomId =
            await _userRepository.createChatRoom(event.receiverId);
        emit(ChatRoomCreated(chatRoomId: newChatRoomId));
        emit(ChatRoomLoaded(chatRoomId: newChatRoomId));
      }
    });

    on<FetchUsersEvent>((event, emit) async {
      emit(ChatLoading());
      final users = await _userRepository.fetchUsersByName(event.name);
      if (users.isNotEmpty) {
        emit(ChatUsersLoaded(users: users));
      } else {
        emit(ChatError(error: 'No users found'));
      }
    });

    on<FetchMessagesEvent>((event, emit) async {
      final messagesStream = _userRepository.getMessages(event.chatId);
      await emit.forEach<List<Message>>(
        messagesStream,
        onData: (messages) => ChatMessagesLoaded(messages: messages),
        onError: (_, __) => ChatError(error: 'Error fetching messages'),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      await _userRepository.sendMessage(
          event.chatId, event.receiverId, event.message);
      emit(ChatMessagesSent());

      add(FetchMessagesEvent(chatId: event.chatId));
    });
  }
}
