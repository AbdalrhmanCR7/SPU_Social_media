import 'package:equatable/equatable.dart';
import '../../../core/entities/entity/file_entity.dart';
import '../data/models/post_model.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

  class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostFileUploaded extends PostState {
  final FileEntities file;

  const PostFileUploaded(this.file);

  @override
  List<Object?> get props => [file];
}

class PostFilesUploaded extends PostState {
  final List<FileEntities> files;

  const PostFilesUploaded(this.files);

  @override
  List<Object?> get props => [files];
}

class PostUpdated extends PostState {
  final Post updatedPost;

  const PostUpdated(this.updatedPost);

  @override
  List<Object?> get props => [updatedPost];
}

class PostCreated extends PostState {
  final Post post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}

final class UserPostLoadedState extends PostState {
  final UserPost userPost;

  const UserPostLoadedState({required this.userPost});

  @override
  List<Object?> get props => [userPost];
}