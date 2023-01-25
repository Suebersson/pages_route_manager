part of './route_manager.dart';

/// Criar rotas de páginas[Widget] simplficada e dinâmica sem tratar os
/// parâmetros e argumetos das rotas
@immutable
class CreatePageRoute {
  final String _name;
  final WidgetBuilder _builder;

  static final List<CreatePageRoute> _list = [];
  static List<CreatePageRoute> get list => [..._list];

  /// Criar uma instância
  const CreatePageRoute._(this._name, this._builder);

  /// Criar uma [CreatePageRoute] e adicionar a [_list] automaticamente
  factory CreatePageRoute(String name, WidgetBuilder builder) {
    if (name.isEmpty) {
      return throw CreatePageRouteExecption(
          'O nome da rota não pode ser uma string vazia');
    }
    if (CreatePageRoute._list.any((r) => r._name == name)) {
      return throw CreatePageRouteExecption(
          'Já existe uma rota com esse nome: $name, crie uma rota com um nome diferente das que já foram criadas');
    }

    return CreatePageRoute._(name, builder)._addRoute();
  }

  /// Criar uma instância de [CreatePageRoute] sem adicionar a [list]
  /// e chamar o construtor para uma rota desconhecida
  factory CreatePageRoute.unknowRoute(String name) {
    return CreatePageRoute._(name, RouteManager.onUnKnowRouteBuilder);
  }

  /// Obter o objeto [WidgetBuilder] através do nome da rotas dentro de [CreatePageRoute._list]
  static WidgetBuilder getBuilder(String name) {
    return CreatePageRoute._list
        .firstWhere(
          (route) => route._name == name,
          orElse: () => CreatePageRoute.unknowRoute(name),
        )
        ._builder;
  }

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {
        return RouteManager.appDefaultRoutesTransition(
            builder: settings.getBuilder, settings: settings);
      };
}

extension GetBuilder on RouteSettings {
  /// Obter o objeto [WidgetBuilder] através do nome da rotas dentro de [CreatePageRoute._list]
  WidgetBuilder get getBuilder => CreatePageRoute._list
      .firstWhere(
        (route) => route._name == name,
        orElse: () => CreatePageRoute.unknowRoute(name ?? 'undefined'),
      )
      ._builder;
}

extension AddRoute on CreatePageRoute {
  String get name => _name;
  WidgetBuilder get builder => _builder;

  CreatePageRoute _addRoute() {
    CreatePageRoute._list.add(this);
    return this;
  }

  /// Navegar para essa página/rota
  Future<O?> push<O>([Object? argument]) {
    return RouteNavigator.push<O>(
        builder: _builder,
        settings: RouteSettings(name: _name, arguments: argument));
  }

  /// Substituir a página/rota atual por essa rota
  Future<O?> pushReplacement<O, TO>({Object? argument, TO? result}) async {
    return RouteNavigator.pushReplacement<O, TO>(
        builder: _builder,
        settings: RouteSettings(name: _name, arguments: argument),
        result: result);
  }

  /// Navegar para essa rota e fechar as rotas anteriores até uma rota definida
  Future<O?> pushAndRemoveUntil<O>(
      {required RoutePredicate predicate, Object? argument}) async {
    return RouteNavigator.pushAndRemoveUntil<O>(
      builder: _builder,
      settings: RouteSettings(name: _name, arguments: argument),
      predicate: predicate,
    );
  }

  /// Fechar a página/rota atual e navegar para essa rota
  Future<O?> popAndPush<O, TO>({TO? result, Object? arguments}) {
    RouteNavigator.pop<TO>(result);
    return push<O>(arguments);
  }
}

class CreatePageRouteExecption implements Exception {
  final String message;

  CreatePageRouteExecption(this.message);

  @override
  String toString() => message;
}
