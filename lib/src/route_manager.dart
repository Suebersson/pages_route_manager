import 'package:flutter/cupertino.dart' show CupertinoApp, CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;
import 'package:dependency_manager/dependency_manager.dart'
    show dependencyDispose;

part './widgets/widget_transition_animation.dart';
part './widgets/unknow_route_builder.dart';
part './widgets/bind_page_builder.dart';
part './widgets/stateless_argument.dart';
part './route_observer_provider.dart';
part './screen_route_builder.dart';
part './page_route_transition.dart';
part './platform_page_transitions_builder.dart';
part './create_page_route.dart';
part './route_navigator.dart';

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
    [RouteManager.routeManagerWatcher] esteja atribuida no [MaterialApp] >> [navigatorObservers]
*/

extension ImplementFunction on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get mediaQuerySize => mediaQuery.size;
  TargetPlatform get platform => Theme.of(this).platform;
  NavigatorState get navigator => Navigator.of(this);
  ModalRoute? get modalRoute => ModalRoute.of(this);
  FocusScopeNode get focusScopeNode => FocusScope.of(this);
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);
  IconThemeData get iconTheme => IconTheme.of(this);

  /// Obter o argumento[Object] passado como parâmetro dentro de [RouteSettings]
  /// para a rota de atual já convertido[cast]
  O? getArgument<O>() {
    RouteSettings? settings = modalRoute?.settings;

    if (settings?.arguments is O) {
      return settings?.arguments as O;
    } else {
      printLog(
        "O argumento é nulo, passe um [Object] nas propriedades 'settings' ou 'arguments' para essa página",
        name: settings?.name ?? 'RouteManager',
      );
      return null;
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
  static RouteTransionFunction get appDefaultRoutesTransition =>
      _appDefaultRoutesTransition ?? PageRouteTransition._screenRouteBuilder;
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

  /// Obter os dados da [Route] atual apenas se página tiver herança com [PageRoute]
  /// [MaterialPageRoute], [CupertinoPageRoute], [PageRouteBuilder],
  /// [ScreenRouteBuilder]
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

  /// Comparar se as instâncias do [Navigator] de [RouteManager.currentNavigator]
  /// e [Navigator.of] são iguais
  ///
  /// O parâmetro [contextNavigator] deve ser a função [Navigator.of] da página/rota atual
  ///
  static bool compareNavigators(NavigatorState contextNavigator) {
    /// Essa função serve para verificar a confibilidade do objeto [RouteManager.currenteNavigator]
    /// para ser usado na navegação das rotas, portanto, o mesmo é confiavel desde que os objetos
    /// [Navigator] sejam iguais
    ///
    /// Chamada ==> RouteManager.compareNavigators(Navigator.of(context));

    printLog(
        'Instância do RouteManager.navigator: ${currentNavigator.hashCode}',
        name: 'RouteManager');

    printLog('Instância do context.navigator: ${contextNavigator.hashCode}',
        name: 'RouteManager');

    if (identical(currentNavigator, contextNavigator) &&
        currentNavigator.hashCode == contextNavigator.hashCode) {
      printLog('Resultado: as instâncias são iguais', name: 'true');
      return true;
    } else {
      printLog('Resultado: as instâncias são diferentes', name: 'false');
      return false;
    }
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

/// Obter o argumento[Object] passado como parâmetro dentro de [RouteSettings]
/// para a rota de atual já convertido[cast]
O? getArgument<O>() {
  // Essa função é global para que o argumento possa ser acessado sem o contexto,
  // dentro ou fora dos objetos [StatelessWidget] e [StatefulWidget], sem ser
  // [static] para que não gerar erro no desenvolvimento

  if (RouteManager._currentRouteSettings?.arguments is O) {
    return RouteManager._currentRouteSettings?.arguments as O;
  } else {
    printLog(
      "O argumento é nulo, passe um [Object] nas propriedades 'settings' ou 'arguments' para essa página",
      name: RouteManager._currentRouteSettings?.name ?? 'RouteManager',
    );
    return null;
  }
}
