import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;
import 'package:dependency_manager/dependency_manager.dart'
    show dependencyDispose;

part 'widget_transition_animation.dart';
part 'route_observer_provider.dart';
part 'unknow_route_builder.dart';
part 'screen_route_builder.dart';
part 'page_route_transition.dart';
part 'bind_page_builder.dart';

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

abstract class RouteManager {
  /// Navigator que será definida quando a rota inicial da app for carregada.
  /// O uso da mesma deve ser evitada, menos que o dev saiba como usa-lá
  static NavigatorState? rootNavigator;

  /// Navigator que é atualizada a cada ação executada através na [MaterialApp.navigatorObservers]
  /// usando objeto [routeManagerWatcher]
  static NavigatorState? currentNavigator;

  /// Observar as transições das rotas
  static final NavigatorObserver routeManagerWatcher =
      RouteObserverProvider<PageRoute>(
    didPush_: ({required Route<dynamic> route, Route<dynamic>? previousRoute}) {
      if (route is PageRoute) {
        if (route.isFirst) {
          rootNavigator = route.navigator;
          currentNavigator = route.navigator;
        } else {
          currentNavigator = route.navigator;
        }
      }
    },
    didPop_: ({required Route<dynamic> route, Route<dynamic>? previousRoute}) {
      if (previousRoute is PageRoute) {
        currentNavigator = previousRoute.navigator;
      }
    },
    didReplace_: ({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
      if (newRoute is PageRoute) {
        if (newRoute.isFirst) {
          rootNavigator = newRoute.navigator;
          currentNavigator = newRoute.navigator;
        } else {
          currentNavigator = newRoute.navigator;
        }
      }
    },
    didRemove_: (
        {required Route<dynamic> route, Route<dynamic>? previousRoute}) {
      if (route is PageRoute) {
        if (route.isFirst) {
          rootNavigator = route.navigator;
          currentNavigator = route.navigator;
        } else {
          currentNavigator = route.navigator;
        }
      }
    },
  );

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

  static WidgetBuilder get onUnKnowRouteBuilder =>
      (_) => const UnKnowRouteBuilder();
}
