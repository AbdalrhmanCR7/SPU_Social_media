import 'package:social_media_app/features/chat/data/models/chat_user.dart';
import '../data_sources/chat_remote_data_source.dart';

  class UserRepository {
  final ChatRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<List<UserChat>> fetchUsersByName(String name) async {
    try {
      return await remoteDataSource.fetchUsersByName(name);
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
}
