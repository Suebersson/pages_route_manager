part of '../route_manager.dart';

abstract class StatelessArgument<A> extends Widget {
  const StatelessArgument({Key? key}) : super(key: key);

  @override
  _StatelessArgumentElement createElement() =>
      _StatelessArgumentElement<A>(this);

  @protected
  Widget build(BuildContext context, A? argument);
}

class _StatelessArgumentElement<A> extends ComponentElement {
  _StatelessArgumentElement(StatelessArgument widget) : super(widget);
  // _StatelessArgumentElement(StatelessArgument super.widget);

  @override
  StatelessArgument get widget => super.widget as StatelessArgument;

  @override
  Widget build() => widget.build(this, this.getArgument<A>());
  // Widget build() => (widget as StatelessArgument).build(this, this.getArgument<A>());

  @override
  void update(StatelessArgument newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    // _dirty = true;
    rebuild();
  }
}
