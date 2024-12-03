part of 'post_bloc.dart';

enum BlocStatus {
  initial,
  loading,
  error,
  success,
}

class PostState extends Equatable {
  final Uint8List? image;
  final BlocStatus postStatus;

  const PostState({
    required this.image,
    required this.postStatus,
  });

  factory PostState.initial() {
    return const PostState(
      image: null,
      postStatus: BlocStatus.initial,
    );
  }

  @override
  List<Object?> get props => [image,postStatus,];

  PostState copyWith({
    Uint8List? image,
    BlocStatus? postStatus,
  }) {
    return PostState(
      image: image ?? this.image,
      postStatus: postStatus ?? this.postStatus,
    );
  }
}
