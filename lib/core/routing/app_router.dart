import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';

import '../../features/login/bloc/login_bloc.dart';
import '../../features/login/presentation/pages/login_screen.dart';
import '../../features/register/bloc/register_bloc.dart';
import '../../features/register/presentation/pages/register_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.initialPage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(),
            child: const LoginPage(),
          ),
        );
      case Routes.loginPage:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case Routes.registerPage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(),
            child: const RegisterPage(),
          ),
        );
      case Routes.homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),


        );
      default:
        return null;
    }
  }
}
