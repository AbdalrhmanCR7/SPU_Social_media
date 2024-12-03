import 'package:social_media_app/features/post/data/models/post_model.dart';

import 'package:dartz/dartz.dart';
import 'package:social_media_app/core/error/failures.dart';

import '../data_sources/post_data_source.dart';


class PostRepository {
  final NewPostsRemoteDataSource remoteDataSource;

  PostRepository(this.remoteDataSource);

  Future<Either<Failure, void>> createPost(Post post) async {
    try {
      await remoteDataSource.createPost(post);
      return const Right(null);
    } catch (e) {

      return const Left(ServerFailure(errorMessage: 'Failed to create post'));
    }
  }

  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } catch (e) {

      return const Left(ServerFailure(errorMessage: 'Failed to delete post'));
    }
  }

  Future<Either<Failure, List<Post>>> fetchAllPosts() async {
    try {
      final allPosts = await remoteDataSource.fetchAllPosts();
      return Right(allPosts);
    } catch (e) {

      return const Left(ServerFailure(errorMessage: 'Failed to fetch all posts'));
    }
  }

  Future<Either<Failure, List<Post>>> fetchPostByUserId(String userId) async {
    try {
      final userPosts = await remoteDataSource.fetchPostByUserId(userId);
      return Right(userPosts);
    } catch (e) {

      return const Left(ServerFailure(errorMessage: 'Failed to fetch posts by user ID'));
    }
  }
}





// final NewPostsRemoteDataSource remoteDataSource;
//
// PostRepository(this.remoteDataSource);
//
// Future<Either<Failure, void>> addPost(Post post) async {
//   try {
//     await remoteDataSource.createPost(post);
//     return const Right(null);
//   } catch (e) {
//     return const Left(ServerFailure(errorMessage: 'Something went wrong'));
//   }
// }
//
// Future<Either<Failure, void>> uploadFile(XFileEntities xFileEntities, String folderName) async {
//   try {
//     return const Right(null);
//   } catch (e) {
//     return const Left(ServerFailure(errorMessage: 'Something went wrong'));
//   }
// }
//
// Future<List<Post>> fetchPosts() async {
//   final snapshot = await remoteDataSource.fetchPosts();
//   return snapshot.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList();
// }

