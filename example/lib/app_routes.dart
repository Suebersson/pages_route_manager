library app_route;

import 'package:flutter/widgets.dart';
import 'package:pages_route_manager/pages_route_manager.dart';

import './pages/home_page.dart';
import './pages/any_page.dart';

/// Unir [RouteName], [AppRoutes] com a package [RouteManager]
export 'package:pages_route_manager/pages_route_manager.dart';
export 'app_routes.dart';

abstract class RouteName{

  static final RouteModel homePage = RouteModel('/', (_) => const HomePage());

  static final RouteModel anyPage = RouteModel('/anyPage', (_) => const AnyPage());

}

@immutable
class RouteModel {

  final String _name;
  final WidgetBuilder _builder;

  // Para criar as rotas, devemos usar apenas o construtor factory e não esse construtor privado
  const RouteModel._(this._name, this._builder);

  factory RouteModel(String name, WidgetBuilder builder){
    return RouteModel._(name, builder)._addRoute();
  }

}

extension RouteAttributes on RouteModel {

  String get name => _name;
  WidgetBuilder get builder => _builder;

  RouteModel _addRoute() {
    AppRoutes._listRoutes.add(this);
    return this;
  }

}

/// Essa estrutura de código nos possibilita adicionar as rotas usando o objeto [RouteModel]
/// dentro de [RouteName] sem precisar reescrever(repetir) o nome[String] e o construtor[WidgetBuilder]
/// em outras classes ou objetos. Basta apenas criar uma instância de [RouteModel] dentro de [RouteName]
/// 
/// E na medida que o número de rotas aumente na app, o objeto onGenerateRoute[RouteFactory]
/// é dinâmico e não precisar ser alterado(fazer uma implementação)
abstract class AppRoutes {

  static final List<RouteModel> _listRoutes = [];
  static List<RouteModel> get listRoutes => [..._listRoutes];

  /// Transição de páginas/rotas padrão da app 
  static Route<R> appRouteTransition<R>(
    {required WidgetBuilder builder, RouteSettings? settings}) {

    return PageRouteTransition.customized<R>(
      builder: builder,
      settings: settings
    );

    // return MaterialPageRoute( //CupertinoPageRoute
    //   builder: builder,
    //   settings: settings
    // );
  }

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {

    return appRouteTransition<ScreenRouteBuilder>(
      builder: _listRoutes
        .firstWhere(
          (routeModel) => routeModel._name == settings.name,
          orElse: () => RouteModel._(settings.name ?? 'undefined', RouteManager.onUnKnowRouteBuilder),
        )._builder,
      settings: settings
    );

  };

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