
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_event.dart';
import 'chat_state.dart';
import '../data/repositories/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserRepository _userRepository;

  ChatBloc(this._userRepository) : super(ChatInitial()) {
    // جلب المستخدمين حسب الاسم
    on<FetchUsersEvent>((event, emit) async {
      emit(ChatLoading());

        final users = await _userRepository.fetchUsersByName(event.name);
        if (users.isNotEmpty) {
          emit(ChatUsersLoaded(user: users.first)); // عرض أول مستخدم فقط
        } else {
          emit(ChatError(error: 'No users found'));
        }



    });

    // جلب الرسائل بين مستخدمين
    on<FetchMessagesEvent>((event, emit) async {
      final messagesStream = _userRepository.getMessages(event.currentUserId, event.receiverId);
      await emit.forEach<List<Map<String, dynamic>>>(
        messagesStream,
        onData: (messages) {
          print('Messages loaded: ${messages.length}');
          return ChatMessagesLoaded(messages: messages);
        },
        onError: (_, __) => ChatError(error: 'Error fetching messages'),
      );
    });



    // إرسال رسالة
    on<SendMessageEvent>((event, emit) async {
      try {
        await _userRepository.sendMessage(event.senderId, event.receiverId, event.message);
        emit(ChatMessagesSent());
        // جلب الرسائل مباشرة بعد الإرسال لضمان التحديث
        add(FetchMessagesEvent(currentUserId: event.senderId, receiverId: event.receiverId));
      } catch (e) {
        emit(ChatError(error: 'Error sending message: $e'));
      }
    });



  }
}
