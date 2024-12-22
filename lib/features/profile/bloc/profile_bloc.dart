import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/profile/bloc/profile_event.dart';
import 'package:social_media_app/features/profile/bloc/profile_state.dart';

import '../data/repositories/profile_repository.dart';

final TextEditingController _bioController = TextEditingController();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(ProfileLoadingState());
      final result = await _profileRepository.fetchUserProfile();
      result.fold(
            (failure) => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (data) => emit(LoadedState(profileUser: data!)),
      );
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(ProfileLoadingState());
      final result = await _profileRepository.updateProfile(event.updatedProfile);
      result.fold(
            (failure) => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (_) => emit(LoadedState(profileUser: event.updatedProfile)),
      );
    });
  }
}
