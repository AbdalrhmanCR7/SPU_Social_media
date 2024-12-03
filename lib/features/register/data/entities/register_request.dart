import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String name;
  final int id;
  
  
  const RegisterRequest(
       this.id, {
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    name,
    id,
  ];
}