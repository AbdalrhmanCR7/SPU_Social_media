
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/profile/data/entities/profileUser.dart';

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

  LoadedState( { required this.profileUser});

  @override
  List<Object?> get props => [profileUser];
}
