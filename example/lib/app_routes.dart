library app_route;

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:pages_route_manager/pages_route_manager.dart';

import './pages/home_page.dart';
import './pages/any_page.dart';
import './pages/login.dart';

/// Unir [RouteName] com a package [RouteManager]
export 'package:pages_route_manager/pages_route_manager.dart';
export 'app_routes.dart';

abstract class RouteName{

  // static final CreatePageRoute homePage = CreatePageRoute('/', (_) => const HomePage());

  static final CreatePageRoute homePage = CreatePageRoute.initialRoute(
    homePageBuilder: HomePage.rote,
    alternativeBuilder: Login.rote,
    initialRouteTest: computerTest
  );


  static final CreatePageRoute anyPage = CreatePageRoute(AnyPage.name, AnyPage.rote);

}


/// Transição de páginas/rotas padrão da app 
RouteTransionFunction get appRouteTransition {
  /// [TargetPlatform.android], [TargetPlatform.windows], [TargetPlatform.linux]
  if (Platform.isAndroid || Platform.isWindows || Platform.isLinux) {
    return materialAppRouteTransition;
  } else {
  /// [TargetPlatform.IOS], [TargetPlatform.macOS]
    return cupertinoAppRouteTransition;
  }
}

Route<R> materialAppRouteTransition<R>(
  {required WidgetBuilder builder, RouteSettings? settings}) {
    return ScreenRouteBuilder(
      builder: builder,
      settings: settings,
    );
}

Route<R> cupertinoAppRouteTransition<R>(
  {required WidgetBuilder builder, RouteSettings? settings}) {
    return CupertinoPageRoute(
      builder: builder,
      settings: settings,
    );
}












/*
library app_route;

import 'package:flutter/widgets.dart';
import 'package:pages_route_manager/pages_route_manager.dart';

import './pages/home_page.dart';
import './pages/any_page.dart';

/// Unir [RouteName], [AppRoutes] com a package [RouteManager]
export 'package:pages_route_manager/pages_route_manager.dart';
export 'app_routes.dart';

abstract class RouteName{

  static final CreatePageRoute homePage = CreatePageRoute('/', (_) => const HomePage());

  static final CreatePageRoute anyPage = CreatePageRoute('/anyPage', (_) => const AnyPage());

}

@immutable
class CreatePageRoute {

  final String _name;
  final WidgetBuilder _builder;

  // Para criar as rotas, devemos usar apenas o construtor factory e não esse construtor privado
  const CreatePageRoute._(this._name, this._builder);

  factory CreatePageRoute(String name, WidgetBuilder builder){
    return CreatePageRoute._(name, builder)._addRoute();
  }

}

extension RouteAttributes on CreatePageRoute {

  String get name => _name;
  WidgetBuilder get builder => _builder;

  CreatePageRoute _addRoute() {
    AppRoutes._listRoutes.add(this);
    return this;
  }

}

/// Essa estrutura de código nos possibilita adicionar as rotas usando o objeto [CreatePageRoute]
/// dentro de [RouteName] sem precisar reescrever(repetir) o nome[String] e o construtor[WidgetBuilder]
/// em outras classes ou objetos. Basta apenas criar uma instância de [CreatePageRoute] dentro de [RouteName]
/// 
/// E na medida que o número de rotas aumente na app, o objeto onGenerateRoute[RouteFactory]
/// é dinâmico e não precisar ser alterado(fazer uma implementação)
abstract class AppRoutes {

  static final List<CreatePageRoute> _listRoutes = [];
  static List<CreatePageRoute> get listRoutes => [..._listRoutes];

  /// Transição de páginas/rotas padrão da app 
  static Route<R> appRouteTransition<R>(
    {required WidgetBuilder builder, RouteSettings? settings}) {

    // return PageRouteTransition.customized<R>(
    //   builder: builder,
    //   settings: settings,
    //   transitionType: TransitionType.theme
    // );

    // return CupertinoPageRoute(
    // return MaterialPageRoute( 
    return ScreenRouteBuilder(
      builder: builder,
      settings: settings
    );
    
  }

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {

    return appRouteTransition<ScreenRouteBuilder>(
      builder: _listRoutes
        .firstWhere(
          (CreatePageRoute) => CreatePageRoute._name == settings.name,
          orElse: () => CreatePageRoute._(settings.name ?? 'undefined', RouteManager.onUnKnowRouteBuilder),
        )._builder,
      settings: settings
    );

  };

}

*/
















/*
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

*/