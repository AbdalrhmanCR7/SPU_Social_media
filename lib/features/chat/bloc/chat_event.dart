import 'dart:io';

abstract class ChatEvent {}

class FetchUsersEvent extends ChatEvent {
  final String name;
  FetchUsersEvent({required this.name});
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

class ViewUsersEvent extends ChatEvent {}

class DeleteMessageEvent extends ChatEvent {
  final String chatId;
  final String messageId;

  DeleteMessageEvent({required this.chatId, required this.messageId});
}

class UpdateMessageEvent extends ChatEvent {
  final String chatId;
  final String messageId;
  final String updatedMessage;

  UpdateMessageEvent({
    required this.chatId,
    required this.messageId,
    required this.updatedMessage,
  });

}







//
// class SendMediaEvent extends ChatEvent {
//   final String chatId;
//   final String receiverId;
//   final String mediaUrl; // رابط الوسائط
//   final String mediaType; // نوع الوسائط (image أو video)
//
//   SendMediaEvent({
//     required this.chatId,
//     required this.receiverId,
//     required this.mediaUrl,
//     required this.mediaType,
//   });
// }
// class UploadMediaEvent extends ChatEvent {
//   final File file;
//   final String folder;
//
//   UploadMediaEvent({required this.file, required this.folder});
// }
// class SendMediaMessageEvent extends ChatEvent {
//   final String chatId;
//   final String receiverId;
//   final File file;
//
//   SendMediaMessageEvent({
//     required this.chatId,
//     required this.receiverId,
//     required this.file,
//   });
// }