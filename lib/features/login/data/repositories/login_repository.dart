import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/login/data/data_sources/login_remote_data_source.dart';
import '../../../../app/data/data_source/app_local_data_source.dart';
import '../../../../core/error/failures.dart';
class LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource = LoginRemoteDataSource();
  final AppLocalDataSource _appLocalDataSource = AppLocalDataSource();
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
       final String userUId = await loginRemoteDataSource.login(email: email, password: password);
      await _appLocalDataSource.setUserLoggedInStatus(true);
      await _appLocalDataSource.setUserId(userUId);

      return const Right(null);
    } catch (e) {
      debugPrint("Error: $e");
      return const Left(ServerFailure(errorMessage: 'Something went wrong'));
    }
  }
}


