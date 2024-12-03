part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends PostEvent {
  final String content;
  final XFile? file;

  const CreatePost({required this.content, this.file});

  @override
  List<Object> get props => [content, file ?? ''];
}

class FetchPosts extends PostEvent {}

class SelectImage extends PostEvent {}