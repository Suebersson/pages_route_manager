part of './route_manager.dart';

/// Criar rotas de páginas[Widget] simplificada e dinâmica sem tratar os
/// parâmetros e argumetos das rotas
@immutable
class CreatePageRoute {
  final String _name;
  final WidgetBuilder _builder;

  static final List<CreatePageRoute> _list = [];
  static List<CreatePageRoute> get list => [..._list];
  static _InitialRouteData? _initialRouteData;

  const CreatePageRoute._(this._name, this._builder);

  /// Criar uma rota inicial de nome ['/'] com duas páginas[WidgetBuilder] e exibir a página de acordo
  /// com o retorno[bool]  da função[initialRouteTest]
  ///
  /// [homePageBuilder] => true,
  /// [alternativeBuilder] => false
  factory CreatePageRoute.initialRoute(
      {required WidgetBuilder homePageBuilder,
      required WidgetBuilder alternativeBuilder,
      required bool Function() initialRouteTest}) {
    _rulesCreatingRoute('/');

    _initialRouteData = _InitialRouteData(
        name: '/',
        homePageBuilder: homePageBuilder,
        alternativeBuilder: alternativeBuilder,
        initialRouteTest: initialRouteTest,
        status: initialRouteTest.call());

    if (_initialRouteData!.status) {
      return CreatePageRoute._('/', homePageBuilder)._addRoute();
    } else {
      return CreatePageRoute._('/', alternativeBuilder)._addRoute();
    }
  }

  /// Criar uma rota[CreatePageRoute] e adicionar a [_list] automaticamente
  factory CreatePageRoute(String name, WidgetBuilder builder) {
    _rulesCreatingRoute(name);

    return CreatePageRoute._(name, builder)._addRoute();
  }

  static void createPageRoutesFromMapRoutes(Map<String, WidgetBuilder> routes) {
    routes.forEach((routeName, builder) {
      CreatePageRoute(routeName, builder);
    });
  }

  /// Regras para criar uma rota
  static void _rulesCreatingRoute(String name) {
    // não permitir o nome de uma routa com string vazia
    if (name.isEmpty) {
      throw CreatePageRouteExecption(
          'O nome da rota não pode ser uma string vazia');
    }
    // não permitir repetir o name de uma routa
    if (CreatePageRoute._list.any((r) => r._name == name)) {
      throw CreatePageRouteExecption(
          "Já existe uma rota com esse nome: $name, crie uma rota com um nome diferente das que já foram criadas");
    }
  }

  /// Atualizar a rota inicial de acordo com a função [initialRouteTest] inserida no construtor
  /// [CreatePageRoute.initialRoute]
  ///
  /// O parâmetro [argument] será passado para nova página caso a rota seja substituida
  ///
  /// Essa função só deve ser chamada apenas uma vez e dentro da página/rota inicial que será
  /// substituida, caso contrário a mesma não fará nada
  static void upgradeInitialRoute([Object? argument]) {
    /// Essa estrura de código e as condicionais impossibilita o desenvolvendo de cometer
    /// algo erro nas rotas declaradas

    /// se a instância de [_InitialRouteData] for nula, então na o construtor para uma rota
    /// inicial[CreatePageRoute.initialRoute] não foi usado
    ///
    /// ou existe uma instância mais o status é [true], não fazer nada por que
    /// a rota já foi substituida
    if (_initialRouteData == null || _initialRouteData!.status) return;

    /// O status é false e a página atual é [alternativeBuilder]
    ///
    /// Permitir atualizar a rotas inicial somente se a rota atual tiver o mesmo
    /// nome da rota inicial definida no construtos [CreatePageRoute.initialRoute]
    ///
    /// chamar a função de teste e verificar o nome da rota, se as duas condições for [true],
    /// alterar a página/rota atual
    if (_initialRouteData!.initialRouteTest.call() &&
        RouteManager.currentRouteSettings?.name == _initialRouteData!.name) {
      /*
        A uso do construtor [CreatePageRoute.initialRoute] serve para 
        computar/testar qual página[WidgetBuilder] deve ser exibida na inicialização da app

        Supondo que a função [initialRouteTest] retorne false, a página que será exibida será
        a [alternativeBuilder], caso seja true retornará [homePageBuilder].

        No caso de a app inicializar com página [alternativeBuilder], para refazer a computação 
        de teste, basta apenas chamar a função [upgradeInitialRoute] dentro da página/rota inicial

        Ex: Testar se um usuário está logado na app usando a função [initialRouteTest] para
            decidir qual página deve ser exibida.
            
            supondo que seja uma tela de login[alternativeBuilder],
            após fazer o login basta apenas chamar a função de teste[initialRouteTest] dentro da mesma

      */

      _list.removeWhere((route) => route._name == _initialRouteData!.name);

      _initialRouteData!.status = true;

      CreatePageRoute._(
              _initialRouteData!.name, _initialRouteData!.homePageBuilder)
          ._addRoute()
          .pushReplacement(argument: argument);
    }
  }

  /// Obter o objeto [WidgetBuilder] através do nome da rotas dentro de [CreatePageRoute._list]
  static WidgetBuilder getBuilder(String name) {
    return CreatePageRoute._list
        .firstWhere(
          (route) => route._name == name,
          orElse: () =>
              CreatePageRoute._(name, RouteManager.onUnKnowRouteBuilder),
        )
        ._builder;
  }

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {
        return RouteManager.appDefaultRoutesTransition(
            builder: settings.getBuilder, settings: settings);
      };
}

extension CreatePageRoutesFromMapRoutes on Map<String, WidgetBuilder> {
  /// Definir e criar as rotas para o gerenciador [RouteManager] > [CreatePageRoute]
  Map<String, WidgetBuilder> createPageRoutesFromMapRoutes() {
    CreatePageRoute.createPageRoutesFromMapRoutes(this);

    return this;
  }
}

extension GetBuilder on RouteSettings {
  /// Obter o objeto [WidgetBuilder] através do nome da rotas dentro de [CreatePageRoute._list]
  WidgetBuilder get getBuilder => CreatePageRoute._list
      .firstWhere(
        (route) => route._name == name,
        orElse: () => CreatePageRoute._(
            name ?? 'undefined', RouteManager.onUnKnowRouteBuilder),
      )
      ._builder;
}

extension CreatePageRouteMethods on CreatePageRoute {
  String get name => _name;
  WidgetBuilder get builder => _builder;

  CreatePageRoute _addRoute() {
    CreatePageRoute._list.add(this);
    return this;
  }

  /// Navegar para essa página[Widget]
  Future<O?> push<O>([Object? argument]) {
    return RouteNavigator.push<O>(
        builder: _builder,
        settings: RouteSettings(name: _name, arguments: argument));
  }

  /// Fechar a página/rota atual
  void pop<O extends Object?>([O? result]) {
    return RouteNavigator.pop<O>(result);
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

class _InitialRouteData {
  final String name;
  final WidgetBuilder homePageBuilder;
  final WidgetBuilder alternativeBuilder;
  final bool Function() initialRouteTest;
  bool status;

  _InitialRouteData(
      {required this.name,
      required this.homePageBuilder,
      required this.alternativeBuilder,
      required this.initialRouteTest,
      required this.status});
}

class CreatePageRouteExecption implements Exception {
  final String message;

  CreatePageRouteExecption(this.message);

  @override
  String toString() => message;
}
