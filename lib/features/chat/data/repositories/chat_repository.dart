
import '../data_sources/chat_remote_data_source.dart';
import '../models/chat_user.dart';

class UserRepository {
  final ChatRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<Stream<List<UserChat>>> fetchUsersByName(String name) async {
    try {
      return remoteDataSource.fetchUsersByName(name);
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    try {
      return remoteDataSource.getMessages(chatId);
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String chatId, String receiverId, String message) async {
    try {
      await remoteDataSource.sendMessage(chatId, receiverId, message);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<String?> getChatRoom(String receiverId) async {
    try {
      return await remoteDataSource.getChatRoom(receiverId);
    } catch (e) {
      throw Exception('Error getting chat room: $e');
    }
  }

  Future<String> createChatRoom(String receiverId) async {
    try {
      return await remoteDataSource.createChatRoom(receiverId);
    } catch (e) {
      throw Exception('Error creating chat room: $e');
    }
  }

  Stream<List<UserChatWithMessage>> fetchUsersWithLastMessage() {
    try {
      return remoteDataSource.viewUsers();
    } catch (e) {
      throw Exception('Error fetching users with message: $e');
    }
  }





  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await remoteDataSource.deleteMessage(chatId, messageId);
    } catch (e) {
      throw Exception('Error deleting message: $e');
    }
  }
  Future<void> updateMessage(String chatId, String messageId, String updatedMessage) async {
    try {
      await remoteDataSource.updateMessage(chatId, messageId, updatedMessage);
    } catch (e) {
      throw Exception('Error updating message: $e');
    }
  }






// Future<void> sendMedia(String chatId, String receiverId, String mediaUrl, String mediaType) async {
//   try {
//     await remoteDataSource.sendMedia(chatId, receiverId, mediaUrl, mediaType);
//   } catch (e) {
//     throw Exception('Error sending media: $e');
//   }
// }
//
// Future<String> uploadMedia(File file, String folder) async {
//   return await remoteDataSource.uploadMedia(file, folder);
// }
}
