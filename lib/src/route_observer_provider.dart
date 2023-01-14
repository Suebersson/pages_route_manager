part of './route_manager.dart';

typedef DidFunction = void Function(
    {required Route route, Route? previousRoute});
typedef DidReplaceFunction = void Function({Route? newRoute, Route? oldRoute});

// Exemplo de uso:
/*
  navigatorObservers: [
    RouteObserverProvider(
      didPush_: ({required Route route, Route? previousRoute}){
        if (route is PageRoute) {
          print('didPush_RouteName: ${route.settings.name}');
          print('didPush_Arguments: ${route.settings.arguments}');

        }
      },
      didPop_: ({required Route route, Route? previousRoute}){
        if (route is PageRoute) {
          print('didPop_RouteName: ${route.settings.name}');
          print('didPop_Arguments: ${route.settings.arguments}');
        }
      },
      didReplace_: ({Route? newRoute, Route? oldRoute}){
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
/// funções quando uma transição de ocorrer, posibilitando passar apenas
/// as funções que necessárias de ocordo com as necessidades do desenvolvimento
class RouteObserverProvider extends NavigatorObserver {
  final DidReplaceFunction? didReplace_;
  final DidFunction? didPush_, didPop_, didRemove_, didStartUserGesture_;
  final void Function()? didStopUserGesture_;

  RouteObserverProvider(
      {this.didPush_,
      this.didReplace_,
      this.didPop_,
      this.didRemove_,
      this.didStartUserGesture_,
      this.didStopUserGesture_});

  NavigatorState? get navigatorState => super.navigator;

  @override
  void didPush(Route route, Route? previousRoute) {
    didPush_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    didReplace_?.call(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    didPop_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    didRemove_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    didStartUserGesture_?.call(route: route, previousRoute: previousRoute);
  }

  @override
  void didStopUserGesture() => didStopUserGesture_?.call();
}
