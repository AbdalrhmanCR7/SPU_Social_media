import 'package:bloc/bloc.dart';

import 'package:social_media_app/features/profile/bloc/profile_event.dart';
import 'package:social_media_app/features/profile/bloc/profile_state.dart';

import '../data/repositories/profile_repository.dart';



class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit)  async{
      emit(ProfileLoadingState());
      final result = await profileRepository.fetchUserProfile(event.uid);
        result.fold(
               (failure) => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
               (profileUser) => emit(LoadedState(profileUser: profileUser!)),
         );

    });
    on<UpdateUserProfile>((event, emit) async{

      emit(ProfileLoadingState());
      final result = await profileRepository.updateProfile(event.updatedProfile);
      result.fold(
            (failure) => emit(ProfileErrorState(errorMessage: failure.errorMessage)),
            (_) => emit(LoadedState(profileUser: event.updatedProfile)),
      );
    }
    );

  }
}
