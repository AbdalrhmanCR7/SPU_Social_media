import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/features/register/data/data_sources/register_data_source.dart';

import '../../../../core/error/failures.dart';

class RegisterRepository {
  final RegisterDataSource _registerDataSource = RegisterDataSource();

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await _registerDataSource.register(
        email: email,
        password: password,
        userName: userName,
      );
      return const Right(null);
    } catch (e) {
      debugPrint("Error: $e");
      return const Left(ServerFailure(errorMessage: 'Something went wrong'));
    }
  }
}
