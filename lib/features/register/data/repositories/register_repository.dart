import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/features/register/data/data_sources/register_remote_data_source.dart';

import '../../../../app/data/data_source/app_local_data_source.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart' as user_entity;
class RegisterRepository {
  final RegisterRemoteDataSource _registerRemoteDataSource =
      RegisterRemoteDataSource();
  final AppLocalDataSource _appLocalDataSource = AppLocalDataSource();

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final  user_entity.Userinfo userinfo= await _registerRemoteDataSource.register(
        email: email,
        password: password,
        userName: userName,
      );


       await _appLocalDataSource.setUserLoggedInStatus(true);
        await _appLocalDataSource.setUserId(userinfo.uid!);

      return const Right(null);
    } catch (e) {
      debugPrint("Error: $e");
      return const Left(ServerFailure(errorMessage: 'Something went wrong'));

    }
  }
}
