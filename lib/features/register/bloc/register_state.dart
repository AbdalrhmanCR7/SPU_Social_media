part of 'register_bloc.dart';

@immutable
sealed class RegisterState extends Equatable {}

final class RegisterInitial extends RegisterState {
  @override
  List<Object?> get props => [];
}

final class LoadingState extends RegisterState {
  @override
  List<Object?> get props => [];
}

final class ErrorState extends RegisterState {
  final String errorMessage;

  ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class SuccessState extends RegisterState {
  @override
  List<Object?> get props => [];
}
