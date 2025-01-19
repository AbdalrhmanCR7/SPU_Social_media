import 'package:social_media_app/features/post/data/models/post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/error/failures.dart';
import '../../../../app/data/data_source/app_local_data_source.dart';
import '../../../../core/entities/entity/file_entity.dart';
import '../../../../core/entities/entity/x_file_entity.dart';
import '../data_sources/post_data_source.dart';

class PostRepository {
  final NewPostsRemoteDataSource remoteDataSource;

  PostRepository(this.remoteDataSource);
  final AppLocalDataSource _appLocalDataSource = AppLocalDataSource();


  // إنشاء منشور جديد
  Future<Either<Failure, void>> createPost(Post post ) async {
    try {
      await remoteDataSource.createPost(post);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to create post'));
    }
  }

  // تعديل منشور
  Future<Either<Failure, void>> updatePost(Post post) async {
    try {
      await remoteDataSource.updatePost(post);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to update post'));
    }
  }

  // حذف منشور
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to delete post'));
    }
  }

  // جلب جميع المنشورات في الوقت الحقيقي
  Stream<Either<Failure, List<Post>>> fetchAllPosts() {
    try {
      return remoteDataSource.fetchAllPosts().map(
            (posts) => Right(posts),
      );
    } catch (e) {
      return Stream.value(const Left(ServerFailure(errorMessage: 'Failed to fetch all posts')));
    }
  }

  // جلب منشورات مستخدم معين في الوقت الحقيقي
  Stream<Either<Failure, List<Post>>> fetchPostByUserId(String userId) {
    try {
      return remoteDataSource.fetchPostByUserId(userId).map(
            (posts) => Right(posts),
      );
    } catch (e) {
      return Stream.value(const Left(ServerFailure(errorMessage: 'Failed to fetch posts by user ID')));
    }
  }

  // جلب بيانات المستخدم استنادًا إلى الـ UID
  Future<Either<Failure, UserPost?>> fetchUserProfile() async {
    try {
      final String uid = await _appLocalDataSource.userId ?? '';
      final userPost = await remoteDataSource.fetchUserPost(uid);
      if (userPost != null) {
        return Right(userPost);
      } else {
        return const Left(
            ServerFailure(errorMessage: 'User profile not found'));
      }
    } catch (e) {
      return const Left(
          ServerFailure(errorMessage: 'Failed to fetch user profile'));
    }
  }

  // رفع عدة ملفات (صور أو ملفات أخرى)
  Future<Either<Failure, List<FileEntities>>> uploadFilesPost(List<XFileEntities> files, String folderName) async {
    try {
      final uploadedFiles = await remoteDataSource.uploadFilesPost(files, folderName);
      return Right(uploadedFiles);
    } catch (e) {
      return const Left(ServerFailure(errorMessage: 'Failed to upload files'));
    }
  }



}
