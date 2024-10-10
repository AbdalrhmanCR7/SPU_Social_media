import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../bloc/login_bloc.dart';
import '../../../../core/widgets/buttons_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;

  void pushHomePage() {
    debugPrint('Login complete');
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homePage,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/back.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(71, 71, 71, 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFd5c48e), width: 5),
                  ),
                ),
                child: Form(
                  key: context.read<LoginBloc>().formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/Slogo.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'User Login',
                            style: TextStyle(
                              color: Color(0xFFd5c48e),
                              fontSize: 22,
                            ),
                          ),
                        ),
                        AuthTextFormField(
                          controller: context.read<LoginBloc>().emailController,
                          prefixIcon: Icons.email_outlined,
                          labelText: 'username',
                          validator: (fullName) {},
                        ),
                        AuthTextFormField(
                          controller:
                              context.read<LoginBloc>().passwordController,
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
                          validator: (fullName) {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "  Don't Have An Account? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFe4d199),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      Routes.registerPage);
                                },
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      start: 10),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: const Text(
                                    "Register now",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Color(0xFFd5c48e),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pushHomePage;
                          },
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color(0xFFe4d199)),
                            fixedSize: const MaterialStatePropertyAll(
                                Size.fromWidth(270)),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
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
        ),
      ),
    );
  }
}
