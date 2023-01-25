part of './route_manager.dart';

/// Abstrações dos métodos da classe [Navigator]
abstract class RouteNavigator {
  //####################### MÉTODOS PARA ROTAS NÃO NOMEADAS ###############################

  /// Navegar para um página[Widget]
  static Future<O?> push<O>(
      {required WidgetBuilder builder, RouteSettings? settings}) async {
    return RouteManager.currentNavigator?.push<O>(
        RouteManager.appDefaultRoutesTransition(
            builder: builder, settings: settings));
  }

  /// Substituir e fechar a página atual por outra
  static Future<O?> pushReplacement<O, TO>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    TO? result,
  }) async {
    return RouteManager.currentNavigator?.pushReplacement<O, TO>(
        RouteManager.appDefaultRoutesTransition(
          builder: builder,
          settings: settings,
        ),
        result: result);
  }

  static Future<O?> pushAndRemoveUntil<O>({
    required WidgetBuilder builder,
    required RoutePredicate predicate,
    RouteSettings? settings,
  }) async {
    //Ex navigator.pushAndRemoveUntil(
    //  MaterialPageRoute...,
    //  (Route<dynamic> predicate) => false
    //);
    return RouteManager.currentNavigator?.pushAndRemoveUntil<O>(
      RouteManager.appDefaultRoutesTransition(
        builder: builder,
        settings: settings,
      ),
      predicate,
    );
  }

  /// Fechar a página/rota atual e navegar para outra
  static Future<O?> popAndPush<O, TO>(
      {required WidgetBuilder builder, RouteSettings? settings, TO? result}) {
    pop<TO>(result);
    return push<O>(builder: builder, settings: settings);
  }

  //####################### MÉTODOS PARA ROTAS NOMEADAS ###############################

  /// Navegar para um página[Widget] nomeada
  static Future<O?> pushNamed<O>(String routeName, {Object? arguments}) async {
    return RouteManager.currentNavigator
        ?.pushNamed<O>(routeName, arguments: arguments);
  }

  static Future<O?> pushNamedAndRemoveUntil<O>({
    required String routeName,
    required RoutePredicate predicate,
    Object? arguments,
  }) async {
    //Ex navigator.pushNamedAndRemoveUntil(
    //  '/newRouteName',
    //  ModalRoute.withName('/routeName')
    //);
    return RouteManager.currentNavigator?.pushNamedAndRemoveUntil<O>(
        routeName, predicate,
        arguments: arguments);
  }

  /// Substituir a página atual por outra pelo nome
  static Future<O?> pushReplacementNamed<O, TO>(String routeName,
      {TO? result, Object? arguments}) async {
    return RouteManager.currentNavigator?.pushReplacementNamed<O, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Fechar a página atual e navegar para outra
  static Future<O?> popAndPushNamed<O, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    pop<TO>(result);
    return pushNamed<O>(routeName, arguments: arguments);
  }

  /// Fechar uma página
  static void pop<O extends Object?>([O? result]) {
    RouteManager.currentNavigator?.pop<O>(result);
  }

  /// Verificar se a página pode ser fechada
  static bool get canPop {
    // assert(currentState != null, "O objeto 'currentNavigator' é null");
    return RouteManager.currentNavigator?.canPop() ?? false;
  }

  static Future<bool> maybePop<O extends Object?>([O? result]) {
    // assert(currentState != null, "O objeto 'currentNavigator' é null");
    return RouteManager.currentNavigator?.maybePop<O>(result) ??
        Future.value(false);
  }
}
