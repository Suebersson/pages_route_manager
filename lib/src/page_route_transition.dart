part of './route_manager.dart';

/// Tipos de objeto [Route] para transição da página
abstract class PageRouteTransition {
  /// Transição para rotas/páginas [MaterialPageRoute] ou [CupertinoPageRoute]
  static Route<R> flutterDefault<R>({
    required WidgetBuilder builder,
    String? title, // Esse parâmetro se aplica apenas ao [CupertinoPageRoute]
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    FlutterDefaultTransition flutterDefaultTransition =
        FlutterDefaultTransition.material,
  }) {
    switch (flutterDefaultTransition) {
      case FlutterDefaultTransition.cupertino:
        return CupertinoPageRoute<R>(
          builder: builder,
          title: title,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
      default:
        return MaterialPageRoute<R>(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
    }
  }

  /// Transição personalizada para rotas/páginas
  static Route<R> customized<R>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    TransitionType transitionType = TransitionType.slideWithScaleRightToLeft,
    Duration transitionDuration = defaultTransitionDuration,
    Duration reverseTransitionDuration = defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return ScreenRouteBuilder<R>(
      builder: builder,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      settings: settings,
      transitionsBuilder:
          (route, context, animation, secondaryAnimation, child) {
        return WidgetTransitionAnimation(
          transitionType: transitionType,
          animation: animation,
          widget: child,
          curve: curve,
          route: route,
        );
      },
    );
  }

  static const Duration defaultTransitionDuration = Duration(milliseconds: 400);
}

enum FlutterDefaultTransition {
  material,
  cupertino,
}
