import 'package:dartz/dartz.dart'; // استخدام مكتبة dartz
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../register/data/entities/user.dart';
import '../data_sources/chat_remote_data_source.dart';
import '../models/chat_user.dart';

class ChatRepository {
  final ChatRemoteDataSource _dataSource;

  ChatRepository(this._dataSource);

  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      await _dataSource.sendMessage(message);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _dataSource.getMessages(chatId);
  }

  Future<Either<Failure, List<Userinfo>>> searchUsers(String query) async {
    try {
      final users = await _dataSource.searchUsers(query);
      return right(users);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, User?>> getUserById(String userId) async {
    try {
      final user = await _dataSource.getUserById(userId);
      return right(user as User?);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}

class Failure {
  final String message;
  Failure({required this.message});
}
