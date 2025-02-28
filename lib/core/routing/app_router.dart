import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';

import '../../features/login/bloc/login_bloc.dart';
import '../../features/login/presentation/pages/login_screen.dart';
import '../../features/post/bloc/post_bloc.dart';
import '../../features/post/data/data_sources/post_data_source.dart';
import '../../features/post/data/repositories/post_repository.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/bloc/profile_event.dart';
import '../../features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/register/bloc/register_bloc.dart';
import '../../features/register/presentation/pages/register_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginPage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(),
            child: const LoginPage(),
          ),
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
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PostBloc>(
                      create: (BuildContext context) => PostBloc(
                        PostRepository(NewPostsRemoteDataSource()),
                      ),
                    ),
                    BlocProvider<ProfileBloc>(
                        create: (BuildContext context) => ProfileBloc(
                            ProfileRepository(ProfileRemoteDataSourceImpl()))
                          ..add(const FetchUserProfile())),
                  ],
                  child: const HomePage(),
                ));

      default:
        return null;
    }
  }
}
