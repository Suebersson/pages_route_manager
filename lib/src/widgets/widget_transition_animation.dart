part of '../route_manager.dart';

/// Widget responsável pela animação definida na transição das rostas
@immutable
class WidgetTransitionAnimation<T> extends StatelessWidget {
  final TransitionType transitionType;
  final Animation<double> animation;
  final Widget widget;
  final Curve curve;
  // Esse parâmetro [route] é obrigatório se o tipo de transição for [TransitionType.theme]
  final PageRoute<T>? route;

  const WidgetTransitionAnimation({
    Key? key,
    required this.transitionType,
    required this.animation,
    required this.widget,
    required this.curve,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case TransitionType.slideLeftToRight:
      case TransitionType.slideRightToLeft:
      case TransitionType.slideTopToBottom:
      case TransitionType.slideBottomToTop:
        return SlideTransition(
          position: animation.drive(
              Tween(begin: _getOffset(transitionType), end: Offset.zero)
                  .chain(CurveTween(curve: curve))),
          child: widget,
        );
      case TransitionType.scaleTopLeft:
      case TransitionType.scaleTopCenter:
      case TransitionType.scaleTopRight:
      case TransitionType.scaleBottomLeft:
      case TransitionType.scaleBottomCenter:
      case TransitionType.scaleBottomRight:
      case TransitionType.scaleCenterLeft:
      case TransitionType.scaleCenter:
      case TransitionType.scaleCenterRight:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.rotateTopLeft:
      case TransitionType.rotateTopCenter:
      case TransitionType.rotateTopRight:
      case TransitionType.rotateBottomLeft:
      case TransitionType.rotateBottomCenter:
      case TransitionType.rotateBottomRight:
      case TransitionType.rotateCenterLeft:
      case TransitionType.rotateCenter:
      case TransitionType.rotateCenterRight:
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.sizeVertical:
      case TransitionType.sizeHorizontal:
        return Center(
          child: SizeTransition(
            // sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            sizeFactor: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
            axis: transitionType == TransitionType.sizeHorizontal
                ? Axis.horizontal
                : Axis.vertical,
          ),
        );
      case TransitionType.slideWithScaleTopToBottom:
      case TransitionType.slideWithScaleLeftToRight:
      case TransitionType.slideWithScaleRightToLeft:
      case TransitionType.slideWithScaleBottomToTop:
        return SlideTransition(
          position: animation.drive(
              Tween(begin: _getOffset(transitionType), end: Offset.zero)
                  .chain(CurveTween(curve: curve))),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
          ),
        );
      case TransitionType.fade:
        return FadeTransition(
          child: widget,
          opacity: animation,
        );
      case TransitionType.fadeWithScaleTopLeft:
      case TransitionType.fadeWithScaleTopCenter:
      case TransitionType.fadeWithScaleTopRight:
      case TransitionType.fadeWithScaleBottomLeft:
      case TransitionType.fadeWithScaleBottomCenter:
      case TransitionType.fadeWithScaleBottomRight:
      case TransitionType.fadeWithScaleCenterLeft:
      case TransitionType.fadeWithScaleCenter:
      case TransitionType.fadeWithScaleCenterRight:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
            alignment: _getAlignment(transitionType),
          ),
        );
      case TransitionType.slideWithFadeTopToBottom:
      case TransitionType.slideWithFadeBottomToTop:
      case TransitionType.slideWithFadeLeftToRight:
      case TransitionType.slideWithFadeRightToLeft:

        /// slide + Fade é a Transição[FadeUpwardsPageTransitionsBuilder] padrão do flutter
        ///  aplicada as plataformas [TargetPlatform.android], [TargetPlatform.linux], [TargetPlatform.windows]
        ///
        /// A difereça são as propriedades usadas: [Offset], [Curves]
        return SlideTransition(
          position: animation.drive(
              Tween(begin: _getOffset(transitionType), end: Offset.zero)
                  .chain(CurveTween(curve: curve))),
          child: FadeTransition(
            child: widget,
            opacity: animation,
          ),
        );
      case TransitionType.withoutAnimation:
        return widget;
      case TransitionType.theme:
        if (route != null) {
          return Theme.of(context)
              .pageTransitionsTheme
              .buildTransitions(route!, context, animation, animation, widget);
        } else {
          printLog("O parâmetro 'route' não foi definido",
              name: 'WidgetTransitionAnimation');
          return widget;
        }
      default:
        return const SizedBox.shrink();
    }
  }
}

Offset _getOffset(TransitionType transitionType) {
  switch (transitionType) {
    case TransitionType.slideLeftToRight:
    case TransitionType.slideWithScaleLeftToRight:
    case TransitionType.slideWithFadeLeftToRight:
      return const Offset(-1.0, 0.0);
    case TransitionType.slideRightToLeft:
    case TransitionType.slideWithScaleRightToLeft:
    case TransitionType.slideWithFadeRightToLeft:
      return const Offset(1.0, 0.0);
    case TransitionType.slideTopToBottom:
    case TransitionType.slideWithScaleTopToBottom:
    case TransitionType.slideWithFadeTopToBottom:
      return const Offset(0.0, -1.0);
    case TransitionType.slideBottomToTop:
    case TransitionType.slideWithScaleBottomToTop:
    case TransitionType.slideWithFadeBottomToTop:
      return const Offset(0.0, 1.0);
    default:
      return const Offset(1.0, 0.0);
  }
}

Alignment _getAlignment(TransitionType transitionType) {
  switch (transitionType) {
    case TransitionType.scaleCenter:
    case TransitionType.rotateCenter:
    case TransitionType.fadeWithScaleCenter:
      return Alignment.center;
    case TransitionType.scaleTopLeft:
    case TransitionType.rotateTopLeft:
    case TransitionType.fadeWithScaleTopLeft:
      return Alignment.topLeft;
    case TransitionType.scaleTopCenter:
    case TransitionType.rotateTopCenter:
    case TransitionType.fadeWithScaleTopCenter:
      return Alignment.topCenter;
    case TransitionType.scaleTopRight:
    case TransitionType.rotateTopRight:
    case TransitionType.fadeWithScaleTopRight:
      return Alignment.topRight;
    case TransitionType.scaleBottomLeft:
    case TransitionType.rotateBottomLeft:
    case TransitionType.fadeWithScaleBottomLeft:
      return Alignment.bottomLeft;
    case TransitionType.scaleBottomCenter:
    case TransitionType.rotateBottomCenter:
    case TransitionType.fadeWithScaleBottomCenter:
      return Alignment.bottomCenter;
    case TransitionType.scaleBottomRight:
    case TransitionType.rotateBottomRight:
    case TransitionType.fadeWithScaleBottomRight:
      return Alignment.bottomRight;
    case TransitionType.scaleCenterLeft:
    case TransitionType.rotateCenterLeft:
    case TransitionType.fadeWithScaleCenterLeft:
      return Alignment.centerLeft;
    case TransitionType.scaleCenterRight:
    case TransitionType.rotateCenterRight:
    case TransitionType.fadeWithScaleCenterRight:
      return Alignment.centerRight;
    default:
      return Alignment.center;
  }
}

enum TransitionType {
  slideLeftToRight,
  slideRightToLeft,
  slideTopToBottom,
  slideBottomToTop,
  scaleCenter,
  scaleTopLeft,
  scaleTopCenter,
  scaleTopRight,
  scaleBottomLeft,
  scaleBottomCenter,
  scaleBottomRight,
  scaleCenterLeft,
  scaleCenterRight,
  rotateCenter,
  rotateTopLeft,
  rotateTopCenter,
  rotateTopRight,
  rotateBottomLeft,
  rotateBottomCenter,
  rotateBottomRight,
  rotateCenterLeft,
  rotateCenterRight,
  sizeVertical,
  sizeHorizontal,
  fade,
  fadeWithScaleCenter,
  fadeWithScaleTopLeft,
  fadeWithScaleTopCenter,
  fadeWithScaleTopRight,
  fadeWithScaleBottomLeft,
  fadeWithScaleBottomCenter,
  fadeWithScaleBottomRight,
  fadeWithScaleCenterLeft,
  fadeWithScaleCenterRight,
  slideWithFadeTopToBottom,
  slideWithFadeLeftToRight,
  slideWithFadeRightToLeft,
  slideWithFadeBottomToTop,
  slideWithScaleTopToBottom,
  slideWithScaleLeftToRight,
  slideWithScaleRightToLeft,
  slideWithScaleBottomToTop,
  theme,
  withoutAnimation,
}
