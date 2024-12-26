import 'package:bloc/bloc.dart';
import 'package:social_media_app/features/profile/bloc/profile_event.dart';
import 'package:social_media_app/features/profile/bloc/profile_state.dart';

import '../data/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(ProfileLoadingState());
      final result = await _profileRepository.fetchUserProfile();
      await result.fold(
            (failure) async => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (data) async => emit(LoadedState(profileUser: data!)),
      );
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(ProfileLoadingState());
      final result = await _profileRepository.updateProfile(event.updatedProfile);
      await result.fold(
            (failure) async => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (_) async => emit(LoadedState(profileUser: event.updatedProfile)),
      );
    });

    on<UploadFileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      final result = await _profileRepository.uploadFile(event.xFileEntities, event.folderName);
      await result.fold(
            (failure) async => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (fileEntities) async {
          final updatedProfile = (state as LoadedState).profileUser.copyWith(
            newProfileImageUrl: fileEntities.url,
          );
          final updateResult = await _profileRepository.updateProfile(updatedProfile);
          await updateResult.fold(
                (failure) async => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
                (_) async {
              emit(LoadedState(profileUser: updatedProfile));
              add(const FetchUserProfile());
            },
          );
        },
      );
    });
  }
}
