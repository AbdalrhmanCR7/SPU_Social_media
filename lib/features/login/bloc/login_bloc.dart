import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/repositories/login_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginRepository loginRepository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<Login>((event, emit) async {
      emit(LoadingState()); // تغيير الحالة إلى حالة تحميل
      final result = await loginRepository.login(
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
