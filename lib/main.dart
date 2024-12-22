import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/data/data_source/app_local_data_source.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final AppLocalDataSource appLocalDataSource = AppLocalDataSource();
  final bool isLoggedIn = await appLocalDataSource.isLoggedIn;
  runApp(
    MyApp(
      appRouter: AppRouter(), isLoggedIn: isLoggedIn,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final bool isLoggedIn ;

  const MyApp({
    super.key,
    required this.appRouter, required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn?Routes.homePage: Routes.loginPage,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
