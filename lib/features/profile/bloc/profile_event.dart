import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/profile/data/entities/profileUser.dart';
import '../../post/data/entity/x_file_entity.dart';

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


