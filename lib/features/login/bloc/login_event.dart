part of 'login_bloc.dart';

sealed class LoginEvent {}

final class Login extends LoginEvent {}

final class LogOut extends LoginEvent {}
