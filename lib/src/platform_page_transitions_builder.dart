part of 'route_manager.dart';

/// Através do objeto[PageTransitionsBuilder], podemos definir a transição personalizada
/// para cada plataforma ou definir a mesma animação para todas
///
/// Animação de transição para usar na propriedade
/// [MaterialApp] >> [ThemeData] >> [PageTransitionsTheme] >> [builders] para as plataformas:
///
/// [TargetPlatform.android], [TargetPlatform.linux], [TargetPlatform.windows],
/// [TargetPlatform.iOS], [TargetPlatform.macOS]
///
@immutable
class PlatformPageTransitionsBuilder extends PageTransitionsBuilder {
  final TransitionType transitionType;
  final Curve curve;

  const PlatformPageTransitionsBuilder({
    required this.transitionType,
    this.curve = Curves.ease,
  });

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return WidgetTransitionAnimation(
      transitionType: transitionType,
      animation: animation,
      widget: child,
      curve: curve,
      route: route,
    );
  }
}
