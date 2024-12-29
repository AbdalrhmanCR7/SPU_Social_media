import 'package:social_media_app/features/chat/data/models/chat_user.dart';

import '../data_sources/chat_remote_data_source.dart';

class UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<List<User>> fetchUsersByName(String name) async {
    try {
      return await remoteDataSource.fetchUsersByName(name);
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String currentUserId, String receiverId) {
    try {
      return remoteDataSource.getMessages(currentUserId, receiverId);
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    try {
      await remoteDataSource.sendMessage(senderId, receiverId, message);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}
