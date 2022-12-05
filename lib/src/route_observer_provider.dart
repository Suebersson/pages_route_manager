part of 'route_manager.dart';

typedef DidPushFunction = void Function(
    {required Route<dynamic> route, Route<dynamic>? previousRoute});
typedef DidReplaceFunction = void Function(
    {Route<dynamic>? newRoute, Route<dynamic>? oldRoute});

// Exemplo de uso:
/*
  navigatorObservers: [
    RouteObserverProvider<PageRoute>(
      didPush_: ({required Route<dynamic> route, Route<dynamic>? previousRoute}){
        if (route is PageRoute) {
          print('didPush_RouteName: ${route.settings.name}');
          print('didPush_Arguments: ${route.settings.arguments}');

        }
      },
      didPop_: ({required Route<dynamic> route, Route<dynamic>? previousRoute}){
        if (route is PageRoute) {
          print('didPop_RouteName: ${route.settings.name}');
          print('didPop_Arguments: ${route.settings.arguments}');
        }
      },
      didReplace_: ({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}){
        if (newRoute is PageRoute && oldRoute is PageRoute) {
          print('didReplace_RouteName: ${newRoute.settings.name}');
          print('didReplace_Arguments: ${newRoute.settings.arguments}');
        }
      }    
    ),
  ],
*/

/// [RouteObserverProvider] é um objeto que facilita a criação de instâncias
/// para observar os eventos sempre que uma rota for alterada e executar
/// funções quando uma transição de ocorrer
class RouteObserverProvider<R extends Route<dynamic>>
    extends NavigatorObserver {
  final DidPushFunction? didPush_;
  final DidReplaceFunction? didReplace_;
  final DidPushFunction? didPop_;
  final DidPushFunction? didRemove_;
  final DidPushFunction? didStartUserGesture_;
  final void Function()? didStopUserGesture_;

  RouteObserverProvider(
      {this.didPush_,
      this.didReplace_,
      this.didPop_,
      this.didRemove_,
      this.didStartUserGesture_,
      this.didStopUserGesture_});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    didPush_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    didReplace_?.call(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    didPop_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    didRemove_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    didStartUserGesture_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didStopUserGesture() => didStopUserGesture_?.call();
}
