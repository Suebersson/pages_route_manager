import 'package:flutter/material.dart';

import 'app_routes.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste route manager',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      initialRoute: RouteName.homePage.name,
      navigatorObservers: [RouteManager.routeManagerWatcher],
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: RouteManager.onUnknownRoute,
    ).setAppRouteTransition(AppRoutes.appRouteTransition);
  }
}
