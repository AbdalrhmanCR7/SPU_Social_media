import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../entities/profileUser.dart';

class ProfileRepository {
  final NewProfileRemoteDataSource remoteDataSource;

  ProfileRepository(this.remoteDataSource );

  Future<Either<Failure, ProfileUser?>> fetchUserProfile(String uid) async {
    try {
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
}
