library app_route;

import 'package:flutter/widgets.dart';
import 'package:pages_route_manager/pages_route_manager.dart';

import './pages/home_page.dart';
import './pages/any_page.dart';

/// Unir [RouteName], [AppRoutes] com a package [RouteManager]
export 'package:pages_route_manager/pages_route_manager.dart';
export 'app_routes.dart';

abstract class RouteName{
  static const String homePage = "/";
  static const String anyPage = "/anyPage";
}

abstract class AppRoutes {

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {

    WidgetBuilder builder; 
    
    if (settings.name == RouteName.homePage) {

      builder = (_) => const HomePage();

    } else if (settings.name == RouteName.anyPage) {

      builder = (_) => const AnyPage();

    } else {
      builder = RouteManager.onUnKnowRouteBuilder;
    }
    
    // ======== Formas de definir o tipo de transição padrão da app ========

    // return CupertinoPageRoute(
    // return MaterialPageRoute(
    //   builder: builder,
    //   settings: settings
    // );

    // return PageRouteTransition.flutterDefault(
    //   builder: builder,
    //   settings: settings
    // );

    return PageRouteTransition.customized(
      builder: builder,
      settings: settings
    );

  };

}
