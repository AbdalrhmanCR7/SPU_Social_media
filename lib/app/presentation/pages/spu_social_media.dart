import 'package:flutter/material.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';

class SPUSocialMedia extends StatelessWidget {
  final AppRouter appRouter;
  const SPUSocialMedia({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPU Social Media',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.homePage,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
