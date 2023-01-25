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
        primaryColor: Colors.blue,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PlatformPageTransitionsBuilder(
              transitionType: TransitionType.slideWithScaleRightToLeft, 
            ),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: PlatformPageTransitionsBuilder(
              transitionType: TransitionType.slideWithScaleRightToLeft, 
            ),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: PlatformPageTransitionsBuilder(
              transitionType: TransitionType.slideWithScaleRightToLeft, 
            ),
          }
        ),
      ),
      initialRoute: RouteName.homePage.name,
      navigatorObservers: [RouteManager.routeManagerWatcher],
      onGenerateRoute: CreatePageRoute.onGenerateRoute,
      onUnknownRoute: RouteManager.onUnknownRoute,
    ).setAppRouteTransition(appRouteTransition);
  }
}
