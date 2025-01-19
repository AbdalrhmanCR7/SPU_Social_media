import 'package:dartz/dartz.dart';
import '../../../../app/data/data_source/app_local_data_source.dart';
import '../../../../core/entities/entity/file_entity.dart';
import '../../../../core/entities/entity/x_file_entity.dart';
import '../../../../core/error/failures.dart';

import '../data_sources/profile_remote_data_source.dart';

import '../models/profileUser.dart';

class ProfileRepository {
  final NewProfileRemoteDataSource remoteDataSource;

  ProfileRepository(this.remoteDataSource);

  final AppLocalDataSource _appLocalDataSource = AppLocalDataSource();

  Future<Either<Failure, ProfileUser?>> fetchUserProfile() async {
    try {
      final String uid = await _appLocalDataSource.userId ?? '';
      final profileUser = await remoteDataSource.fetchUserProfile(uid);
      if (profileUser != null) {
        return Right(profileUser);
      } else {
        return const Left(
            ServerFailure(errorMessage: 'User profile not found'));
      }
    } catch (e) {
      return const Left(
          ServerFailure(errorMessage: 'Failed to fetch user profile'));
    }
  }

  Future<Either<Failure, void>> updateProfile(
      ProfileUser updatedProfile) async {
    try {
      await remoteDataSource.updateProfile(updatedProfile);
      return const Right(null);
    } catch (e) {
      return const Left(
          ServerFailure(errorMessage: 'Failed to update profile'));
    }
  }

  Future<Either<Failure, FileEntities>> uploadFile(
      XFileEntities xFileEntities,
      String folderName,
      ) async {
    try {
      final fileEntities = await remoteDataSource.uploadFile(xFileEntities, folderName);
      return Right(fileEntities);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to upload file'));
    }
  }

  Future<Either<Failure, XFileEntities?>> selectImage() async {
    try {
      final xFileEntities = await remoteDataSource.selectImage();
      return Right(xFileEntities);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to select image'));
    }
  }
}
