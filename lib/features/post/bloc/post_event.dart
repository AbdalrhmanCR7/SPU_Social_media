import 'package:equatable/equatable.dart';
import '../../../core/entities/entity/x_file_entity.dart';
import '../data/models/post_model.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllPostsEvent extends PostEvent {}

class FetchPostsByUserIdEvent extends PostEvent {
  final String userId;

  const FetchPostsByUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreatePostEvent extends PostEvent {
  final Post post;
  const CreatePostEvent(this.post );

  @override
  List<Object?> get props => [post];
}

class DeletePostEvent extends PostEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UploadFilesEvent extends PostEvent {
  final List<XFileEntities> files;
  final String folderName;

  const UploadFilesEvent({required this.files, required this. folderName});

  @override
  List<Object?> get props => [files, folderName];
}

class UpdatePostEvent extends PostEvent {
  final Post updatedPost;

  const UpdatePostEvent(this.updatedPost);

  @override
  List<Object?> get props => [updatedPost];
}

class SelectMultipleImagesPostEvent extends PostEvent {
  const SelectMultipleImagesPostEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserPost extends PostEvent {
   const FetchUserPost();

  @override
  List<Object> get props => [];
}