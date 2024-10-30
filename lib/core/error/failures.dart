import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String? errorMessage,
  }) : super(errorMessage ?? "Something abd wrong");
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String? errorMessage,
  }) : super(errorMessage ?? "Something moh wrong");
}

class GeneralFailure extends Failure {
  const GeneralFailure({
    String errorMessage = "Something jjj wrong",
  }) : super(errorMessage);
}
