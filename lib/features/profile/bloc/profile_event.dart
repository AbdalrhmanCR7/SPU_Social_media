import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/profile/data/models/profileUser.dart';

import '../../../core/entities/entity/x_file_entity.dart';



abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile();

  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends ProfileEvent {
  final ProfileUser updatedProfile;

  const UpdateUserProfile(this.updatedProfile);

  @override
  List<Object> get props => [updatedProfile];
}

class UploadFileEvent extends ProfileEvent {
  final XFileEntities xFileEntities;
  final String folderName;

  const UploadFileEvent({
    required this.xFileEntities,
    required this.folderName,
  });

  @override
  List<Object> get props => [xFileEntities, folderName];
}


class SelectImageEvent extends ProfileEvent {
  const SelectImageEvent();

  @override
  List<Object> get props => [];
}
