import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/profile/data/entities/profileUser.dart';

import '../data/entities/entity/file_entity.dart';
import '../data/entities/entity/x_file_entity.dart';



@immutable
sealed class ProfileState extends Equatable {}

final class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class LoadedState extends ProfileState {
  final ProfileUser profileUser;

  LoadedState({required this.profileUser});

  @override
  List<Object?> get props => [profileUser];
}

final class FileUploadedState extends ProfileState {
  final FileEntities fileEntities;

  FileUploadedState({required this.fileEntities});

  @override
  List<Object?> get props => [fileEntities];
}

final class ImageSelectedState extends ProfileState {
  final XFileEntities? xFileEntities;

  ImageSelectedState({this.xFileEntities});

  @override
  List<Object?> get props => [xFileEntities];
}
