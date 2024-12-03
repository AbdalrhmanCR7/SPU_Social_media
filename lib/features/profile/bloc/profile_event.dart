import 'package:equatable/equatable.dart';

import '../data/entities/profileUser.dart';

sealed class  ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String uid;

  const FetchUserProfile(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateUserProfile extends ProfileEvent {
  final ProfileUser updatedProfile;

  const UpdateUserProfile(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}
