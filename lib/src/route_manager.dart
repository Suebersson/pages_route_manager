import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;
import 'package:dependency_manager/dependency_manager.dart'
    show dependencyDispose;

part './widget_transition_animation.dart';
part './route_observer_provider.dart';
part './unknow_route_builder.dart';
part './screen_route_builder.dart';
part './page_route_transition.dart';
part './bind_page_builder.dart';

/*
  Referências:
  https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
  https://api.flutter.dev/flutter/widgets/NavigatorState-class.html
  https://api.flutter.dev/flutter/widgets/Navigator-class.html
  https://api.flutter.dev/flutter/widgets/GlobalKey-class.html
  https://api.flutter.dev/flutter/material/MaterialApp/onGenerateTitle.html
  https://api.flutter.dev/flutter/widgets/NavigatorObserver-class.html
*/
/* #######################  Responsabilidades dessa package ########################
  - Manter a navegação das rotas da app padrão do flutter(Navigator)
  - Fornecer um base de código para facilitar gerenciamento e controle de rotas da app
  - Fornecer animações na transição de rotas/páginas
  - Fornecer o objeto Navigator, que pissibilitará a navegação sem o contexto desde que a variável 
    [RouteManager.routeManagerWatcher] esteja atribuida no [MaterialApp]
*/

extension ImplementFunction<T> on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get mediaQuerySize => mediaQuery.size;
  TargetPlatform get platform => Theme.of(this).platform;
  NavigatorState get navigator => Navigator.of(this);
  ModalRoute<T>? get modalRoute => ModalRoute.of(this);
  // ignore: avoid_shadowing_type_parameters
  T? getArgument<T>() {
    var arg = modalRoute?.settings.arguments;
    if (arg == null) {
      printLog(
        "O valor do argumento é nulo, verifique se o valor está sendo passado no parâmentro 'RouteSettings' para essa página",
        name: 'RouteManager',
      );
      return null;
    } else {
      return arg as T;
    }
  }
}

abstract class RouteManager<O> {
  /// Navigator que será definida quando a rota inicial da app for carregada.
  /// O uso da mesma deve ser evitada, menos que o dev saiba como usa-lá
  static NavigatorState? get rootNavigator => _rootNavigator;
  static NavigatorState? _rootNavigator;

  /// Navigator que é atualizada a cada ação executada através na [MaterialApp.navigatorObservers]
  /// usando objeto [routeManagerWatcher]
  static NavigatorState? get currentNavigator => _currentNavigator;
  static NavigatorState? _currentNavigator;

  /// Objeto [Route] atual
  static Route? get currentRoute => _currentRoute;
  static Route? _currentRoute;

  /// configurações da página atual
  static RouteSettings? get currentRouteSettings => _currentRouteSettings;
  static RouteSettings? _currentRouteSettings;

  /// Função que retorna o objeto [Route] que será usado para todas as
  /// transições de páginas na app
  static RouteTransionFunction get getAppDefaultRoutesTransition =>
      _appDefaultRoutesTransition ?? PageRouteTransition.flutterDefault;
  static RouteTransionFunction? _appDefaultRoutesTransition;

  /// Observar as transições das rotas
  static final NavigatorObserver routeManagerWatcher = RouteObserverProvider(
    didPush_: ({required Route route, Route? previousRoute}) {
      _setNavigator(route);
    },
    didPop_: ({required Route route, Route? previousRoute}) {
      _setNavigator(previousRoute);
    },
    didReplace_: ({Route? newRoute, Route? oldRoute}) {
      _setNavigator(newRoute);
    },
    didRemove_: ({required Route route, Route? previousRoute}) {
      _setNavigator(route);
    },
  );

  static void _setNavigator(Route? route) {
    if (route is PageRoute) {
      _currentRoute = route;
      _currentRouteSettings = route.settings;

      if (route.isFirst) {
        _rootNavigator = route.navigator;
        _currentNavigator = route.navigator;
      } else {
        _currentNavigator = route.navigator;
      }
    }
  }

  /// Página que será exibida quando o rota for desconhecida ou não existir.
  ///
  /// Este objeto só será chamado apenas se a propriedade [MaterialApp.routes] for definida
  static RouteFactory get onUnknownRoute => (RouteSettings settings) {
        return PageRouteTransition.customized(
          builder: onUnKnowRouteBuilder,
          settings: settings,
          transitionType: TransitionType.scaleCenter,
          curve: Curves.elasticInOut,
        );
      };

  /// Widget/página pronta ser usado na propriedade [onUnknownRoute] do [MaterialApp]
  static WidgetBuilder get onUnKnowRouteBuilder =>
      (_) => const UnKnowRouteBuilder();

  /// Definir transição de rotas/páginas da app
  static void setAppRouteTransition(RouteTransionFunction function) {
    RouteManager._appDefaultRoutesTransition = function;
  }

/* 
========================================================================================

  Exemplos de como usar, reescrever ou criar funções adaptadas para usar o objeto 
  [Navigator], basta apenas usar a propriedade [currentNavigator]

========================================================================================
*/

  /// Navegar para um página[Widget]
  static Future<O?> push<O extends Object?>(
      {required WidgetBuilder builder, RouteSettings? settings}) async {
    return currentNavigator?.push<O>(
        getAppDefaultRoutesTransition(builder: builder, settings: settings));
  }

  /// Navegar para um página[Widget] nomeada
  static Future<O?> pushNamed<O extends Object?>(
      {required String routeName, Object? arguments}) async {
    return currentNavigator?.pushNamed<O>(routeName, arguments: arguments);
  }

  /// Fechar uma página
  static void pop<O extends Object?>([O? result]) {
    currentNavigator?.pop<O>(result);
  }

  /// Verificar se a página pode ser fechada
  static bool get canPop {
    // assert(currentState != null, "O objeto 'currentNavigator' é null");
    return currentNavigator?.canPop() ?? false;
  }

  static Future<bool> maybePop<O extends Object?>([O? result]) {
    // assert(currentState != null, "O objeto 'currentNavigator' é null");
    return currentNavigator?.maybePop<O>(result) ?? Future.value(false);
  }
}

typedef RouteTransionFunction = Route<R> Function<R>(
    {required WidgetBuilder builder, RouteSettings? settings});

extension SetRouteTransitionM on MaterialApp {
  /// Definir transição de rotas/páginas da app
  MaterialApp setAppRouteTransition(RouteTransionFunction function) {
    RouteManager._appDefaultRoutesTransition = function;
    return this;
  }
}

extension SetRouteTransitionC on CupertinoApp {
  /// Definir transição de rotas/páginas da app
  CupertinoApp setAppRouteTransition(RouteTransionFunction function) {
    RouteManager._appDefaultRoutesTransition = function;
    return this;
  }
}
