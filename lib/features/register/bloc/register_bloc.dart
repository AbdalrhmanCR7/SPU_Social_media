import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/repositories/register_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegisterRepository _registerRepository = RegisterRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<Register>((event, emit) async {
      emit(LoadingState());
      final result = await _registerRepository.register(
          email: emailController.text, password: passwordController.text);
      result.fold((failure) {
        Fluttertoast.showToast(
          msg: failure.errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
        emit(ErrorState(errorMessage: failure.errorMessage));
      }, (_) {
        emit(SuccessState());
      });
    });
  }
}
