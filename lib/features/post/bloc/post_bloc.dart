import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/entities/entity/file_entity.dart';
import 'package:social_media_app/features/post/bloc/post_event.dart';
import 'package:social_media_app/features/post/bloc/post_state.dart';
import 'package:social_media_app/features/post/data/models/post_model.dart';
import '../../../core/error/failures.dart';
import '../data/repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  StreamSubscription? _allPostsSubscription;
  StreamSubscription? _userPostsSubscription;

  PostBloc(this.postRepository) : super(PostInitial()) {
    // معالجة حدث FetchAllPostsEvent
    on<FetchAllPostsEvent>((event, emit) async {
      emit(PostLoading());

      await emit.forEach<Either<Failure, List<Post>>>(
        postRepository.fetchAllPosts(),
        onData: (result) => result.fold(
          (failure) => PostError(failure.errorMessage),
          (posts) => PostLoaded(posts),
        ),
        onError: (_, __) => PostError('An unknown error occurred'),
      );
    });

    // معالجة حدث FetchPostsByUserIdEvent
    on<FetchPostsByUserIdEvent>((event, emit) async {
      emit(PostLoading());
      _userPostsSubscription?.cancel(); // إلغاء الاشتراك السابق إن وجد
      _userPostsSubscription =
          postRepository.fetchPostByUserId(event.userId).listen(
        (result) {
          result.fold(
            (failure) => emit(PostError(failure.errorMessage)),
            (posts) => emit(PostLoaded(posts)),
          );
        },
      );
    });

    // معالجة حدث CreatePostEvent
    on<CreatePostEvent>((event, emit) async {
      emit(PostLoading());
      final result = await postRepository.createPost(event.post);
      await result.fold(
        (failure) async => emit(PostError(failure.errorMessage)),
        (_) async {
          emit(PostCreated(event.post)); // إرسال الحالة عندما يتم إنشاء المنشور
          //   add(FetchAllPostsEvent()); // يمكنك جلب المنشورات مرة أخرى بعد رفع المنشور
        },
      );
    });

    // معالجة حدث UpdatePostEvent
    on<UpdatePostEvent>((event, emit) async {
      emit(PostLoading());
      final result = await postRepository.updatePost(event.updatedPost);
      await result.fold(
        (failure) async => emit(PostError(failure.errorMessage)),
        (_) async => emit(PostUpdated(event.updatedPost)),
      );
    });

    // معالجة حدث DeletePostEvent
    on<DeletePostEvent>((event, emit) async {
      emit(PostLoading());
      final result = await postRepository.deletePost(event.postId);
      await result.fold(
        (failure) async => emit(PostError(failure.errorMessage)),
        (_) async {
          add(FetchAllPostsEvent());
        },
      );
    });

    // معالجة حدث UploadFilesEvent

    on<UploadFilesEvent>((event, emit) async {
      emit(PostLoading());

      final uploadResults = await Future.wait(
        event.files.map(
              (file) => postRepository.uploadFilesPost([file], event.folderName),
        ),
      );

      final List<FileEntities> files = [];
      for (final result in uploadResults) {
        result.fold(
              (failure) => emit(PostError(failure.errorMessage)),
              (fileEntities) => files.addAll(fileEntities),
        );
      }

      if (files.isEmpty) {
        emit(PostError("Failed to upload files"));
        return;
      }

      emit(PostFilesUploaded(files));
    });




    on<FetchUserPost>((event, emit) async {
      emit(PostLoading());
      final result = await postRepository.fetchUserProfile();
      await result.fold(
        (failure) async => emit(PostError(failure.errorMessage)),
        (data) async => emit(UserPostLoadedState(userPost: data!)),
      );
    });
  }

  @override
  Future<void> close() {
    // إلغاء الاشتراك عند إغلاق الـ Bloc
    _allPostsSubscription?.cancel();
    _userPostsSubscription?.cancel();
    return super.close();
  }
}
