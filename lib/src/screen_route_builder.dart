part of './route_manager.dart';

class ScreenRouteBuilder<T> extends PageRoute<T> {
  /// Este objeto[ScreenRouteBuilder] do tipo [Route] é uma versão
  /// paralela(uma cópia) do objeto [PageRouteBuilder]
  ///
  /// Ele foi criado e adaptado para receber os parâmetros
  /// [WidgetBuilder] ao invés de uma [RoutePageBuilder]
  /// e [TransitionsBuilder] ao invés de uma [RouteTransitionsBuilder]
  ///
  /// os parâmertros [builder], [transitionsBuilder], [opaque], [barrierDismissible],
  /// [maintainState] e [fullscreenDialog] não podem ser nulos.
  ScreenRouteBuilder({
    required this.builder,
    RouteSettings? settings,
    this.transitionsBuilder = _buildTransitionsFuction,
    this.transitionDuration = PageRouteTransition.defaultTransitionDuration,
    this.reverseTransitionDuration =
        PageRouteTransition.defaultTransitionDuration,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Considerando que o projeto sempre está numa versão null-safety,
  /// não foi necéssario adicionar os [assert] para verificação ne valores nulos

  final WidgetBuilder builder;

  final TransitionsBuilder transitionsBuilder;

  @override
  final Duration transitionDuration, reverseTransitionDuration;

  @override
  final bool opaque, barrierDismissible, maintainState;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
        scopesRoute: true, explicitChildNodes: true, child: builder(context));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionsBuilder(
        this, context, animation, secondaryAnimation, child);
  }
}

typedef TransitionsBuilder = Widget Function(
    PageRoute pageRoute,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child);

Widget _buildTransitionsFuction(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return child;
}
