
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
      final userStream = await _userRepository.fetchUsersByName(event.name);
      await for (final users in userStream) {
        if (users.isNotEmpty) {
          emit(ChatUsersLoaded(users: users));
        } else {
          emit(ChatError(error: 'No users found'));
        }
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


    });
    on<ViewUsersEvent>((event, emit) async {
      emit(ChatLoading());
      final userStream = _userRepository.fetchUsersWithLastMessage();
      await emit.forEach<List<UserChatWithMessage>>(
        userStream,
        onData: (users) => ViewUsersLoaded(users: users),
        onError: (_, __) =>
            ChatError(error: 'Error fetching users with last message'),
      );
    });


    on<DeleteMessageEvent>((event, emit) async {

        emit(ChatLoading());
        await _userRepository.deleteMessage(event.chatId, event.messageId);
        emit(ChatMessageDeleted());
        add(FetchMessagesEvent(chatId: event.chatId));



    });
    on<UpdateMessageEvent>((event, emit) async {

        emit(ChatLoading());
        await _userRepository.updateMessage(
          event.chatId,
          event.messageId,
          event.updatedMessage,
        );
        emit(MessageUpdatedState());

    });
  //
  //   on<SendMediaEvent>((event, emit) async {
  //     emit(ChatLoading());
  //     await _userRepository.sendMedia(
  //       event.chatId,
  //       event.receiverId,
  //       event.mediaUrl,
  //       event.mediaType,
  //     );
  //     emit(ChatMessagesSent());
  //     add(FetchMessagesEvent(chatId: event.chatId)); // تحديث الرسائل بعد الإرسال
  //   });
  //
  //   on<UploadMediaEvent>((event, emit) async {
  //     emit(MediaUploading());
  //     final mediaUrl = await _userRepository.uploadMedia(event.file, event.folder);
  //     emit(MediaUploaded());
  //   });
  //
  //
   }
   }

































