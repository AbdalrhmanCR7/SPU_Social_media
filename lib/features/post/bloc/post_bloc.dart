import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/features/post/data/repositories/post_repository.dart';


part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PostRepository _postRepository;

  PostBloc(
    this._postRepository,
  ) : super(PostState.initial()) {
    on<SelectImage>((event, emit) async {
      emit(state.copyWith(image: null));
      final ImagePicker picker = ImagePicker();
      final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        final Uint8List imageBytes = await xFile.readAsBytes();
        emit(state.copyWith(image: imageBytes));
        on<CreatePost>((event, emit) async {



        });
      }
    });

      


  }
  
  
}
