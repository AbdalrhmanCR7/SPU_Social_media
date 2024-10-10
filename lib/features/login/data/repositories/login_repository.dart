import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/login/bloc/login_bloc.dart';
import 'package:social_media_app/features/login/data/data_sources/login_data_sourece.dart';

import '../../../../core/error/failures.dart';

class LoginRepository {
  final LoginDataSource _loginDataSource = LoginDataSource();

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _loginDataSource.login(email: email, password: password);
      return const Right(null);
    } catch (e) {
      debugPrint("Error: $e");
      return const Left(ServerFailure(errorMessage: 'Something went wrong'));
    }
  }
}

class LogoutRepository {
  final LogoutDataSource _logoutDataSource = LogoutDataSource();

  Future<void> logout() async {
    await _logoutDataSource.Logout();
    return (null);
  }
}
