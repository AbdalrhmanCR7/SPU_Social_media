import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/buttons_widgets.dart';
import '../../../../core/utils/functions.dart';
import '../../bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;

  void pushHomePage() {
    debugPrint('Register complete');
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homePage,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is SuccessState) {
          pushHomePage();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/back.jpg',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(71, 71, 71, 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: const Border(
                        top: BorderSide(color: Color(0xFFd5c48e), width: 5),
                      ),
                    ),
                    child: Form(
                      key: context.read<RegisterBloc>().formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Create new account',
                                style: TextStyle(
                                  color: Color(0xFFd5c48e),
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            AuthTextFormField(
                              controller: context
                                  .read<RegisterBloc>()
                                  .usernameController,
                              prefixIcon: Icons.person,
                              labelText: 'Full Name',
                              validator: (fullName) =>
                                  usernameValidator(fullName),
                              Function: (fullName) {},
                            ),
                            AuthTextFormField(
                              controller:
                                  context.read<RegisterBloc>().emailController,
                              prefixIcon: Icons.email_outlined,
                              labelText: 'Email Address',
                              validator: (email) => emailValidator(email),
                              Function: (fullName) {},
                            ),
                            AuthTextFormField(
                              controller: context
                                  .read<RegisterBloc>()
                                  .passwordController,
                              obscureText: obscureText,
                              prefixIcon: Icons.password,
                              labelText: 'Password',
                              suffixIcon: obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixIconAction: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              validator: (password) =>
                                  passwordValidator(password),
                              Function: (fullName) {},
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (context
                                    .read<RegisterBloc>()
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  context.read<RegisterBloc>().add(Register());
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xFFe4d199),
                                ),
                                fixedSize: const MaterialStatePropertyAll(
                                  Size.fromWidth(270),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Color(0xFF362d0e),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
