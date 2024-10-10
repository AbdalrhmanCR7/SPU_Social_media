part of 'login_bloc.dart';

sealed class LoginState extends Equatable {}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

final class ErrorState extends LoginState {
  final String errorMessage;

  ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class SuccessState extends LoginState {
@override
List<Object?> get props => [];
}
final class LogOutState extends Equatable {
@override
List<Object?> get props => [];

}

