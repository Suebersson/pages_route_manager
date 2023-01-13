### Propriedades adicionadas dentro da BuildContext

- mediaQuery
- mediaQuerySize
- platform
- navigator
- modalRoute
- getArgument

<br />
<br />

### Componentes e objetos
- RouteManager => Tem os métodos e atributos necessários para gerenciar as rotas 
- BindPageBuilder => [Widget], usado para acoplar uma instância de um [Object] para um outro [Widget] (página) filho usar como uma dependência (uma cotroller)
- UnKnowRouteBuilder => [Widget], usado para exibir uma página quando uma rota nomeda não existir
- ScreenRouteBuilder => [PageRoute], objeto criado para navegar para uma página usando uma [WidgetBuilder]
- WidgetTransitionAnimation => [Widget], Todas as animações de transição de rotas
- RouteObserverProvider => [RouteObserver], Modelo para criar um objeto
- PageRouteTransition => Funções que retornam um objeto [Rote] para navegar entre páginas[Widget]
- TransitionType => Contém todos os tipos de animações para transição de rotas e suas variações

<br />
<br />


### Formas de navegar para um página

```dart
// Usando o navigator padrão do flutter
Navigator.of(context).pushNamed(
    RouteName.anyPage.name, 
    arguments: 'data'
);


// Sem o contexto usando o navigator da página ativa
RouteManager.currentNavigator?.pushNamed(
    RouteName.anyPage.name, 
    arguments: 'data'
);

// Sem o contexto usando o navigator da página ativa
RouteManager.push(
  builder: (_) => const AnyPage(), 
  settings: const RouteSettings(name: 'Page2', arguments: 'argument')
);

// Sem o contexto usando o navigator da página ativa
RouteManager.pushNamed(
  routeName: RouteName.anyPage.name,
  arguments: 'argument'
);


// Persolanizando uma animação para transição de uma página
//Navigator.of(context).push(
context.navigator.push(
    PageRouteTransition.customized(
        builder: (_) => const AnyPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionType: TransitionType.fade
    )
);


// Como essa função é possível escolher a transição padrão do flutter
// [MaterialPageRoute] ou [CupertinoPageRoute]
context.navigator.push(
    PageRouteTransition.flutterDefault(
        builder: (_) => const AnyPage(),
    )
);
```

<br />
<br />

### A package tem 7 tipos de animações e suas variações através das propriedades Alignment, Offset e Duration

```dart
// Ex:
    TransitionType.slideWithScaleRightToLeft
```

<br />
<br />
<br />

### Exemplo de uso simple

```dart
// Para ver o exemplo de uso organizado por pasta e arquivos 
// acesse o projeto de exemplo dentro da package ou o repositório no GitHub

import 'package:flutter/material.dart';
import 'package:pages_route_manager/pages_route_manager.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste route manager',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      initialRoute: RouteName.homePage,
      navigatorObservers: [RouteManager.routeManagerWatcher],
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: RouteManager.onUnknownRoute,
    ).setAppRouteTransition(AppRoutes.appRouteTransition);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Center(
        child: ColoredBox(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          child: TextButton(
            onPressed: (){
              /*Navigator.of(context).pushNamed(
                RouteName.anyPage, 
                arguments: 'data'
              );*/
              RouteManager.pushNamed(routeName: RouteName.anyPage.name);
            }, 
            child: const Text(
              'AnyPage',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ), 
          ),
        ),
      ),
    );
  }
}

class AnyPage extends StatelessWidget {
  const AnyPage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnyPage'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Text(context.getArgument<String>() ?? 'argumento não definido'),
      ),
    );
  }
}


abstract class RouteName{

  static final RouteModel homePage = RouteModel('/', (_) => const HomePage());

  static final RouteModel anyPage = RouteModel('/anyPage', (_) => const AnyPage());

}

@immutable
class RouteModel {

  final String _name;
  final WidgetBuilder _builder;

  // Para criar as rotas, devemos usar apenas o construtor factory e não esse construtor privado
  const RouteModel._(this._name, this._builder);

  factory RouteModel(String name, WidgetBuilder builder){
    return RouteModel._(name, builder)._addRoute();
  }

}

extension RouteAttributes on RouteModel {

  String get name => _name;
  WidgetBuilder get builder => _builder;

  RouteModel _addRoute() {
    AppRoutes._listRoutes.add(this);
    return this;
  }

}

/// Essa estrutura de código nos possibilita adicionar as rotas usando o objeto [RouteModel]
/// dentro de [RouteName] sem precisar reescrever(repetir) o nome[String] e o construtor[WidgetBuilder]
/// em outras classes ou objetos. Basta apenas criar uma instância de [RouteModel] dentro de [RouteName]
/// 
/// E na medida que o número de rotas aumente na app, o objeto onGenerateRoute[RouteFactory]
/// é dinâmico e não precisar ser alterado(fazer uma implementação)
abstract class AppRoutes {

  static final List<RouteModel> _listRoutes = [];
  static List<RouteModel> get listRoutes => [..._listRoutes];

  /// Transição de páginas/rotas padrão da app 
  static Route<R> appRouteTransition<R>(
    {required WidgetBuilder builder, RouteSettings? settings}) {

    return PageRouteTransition.customized<R>(
      builder: builder,
      settings: settings
    );

    // return MaterialPageRoute( //CupertinoPageRoute
    //   builder: builder,
    //   settings: settings
    // );
  }

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {

    return appRouteTransition<ScreenRouteBuilder>(
      builder: _listRoutes
        .singleWhere(
          (routeModel) => routeModel._name == settings.name,
          orElse: () => RouteModel._(settings.name ?? 'undefined', RouteManager.onUnKnowRouteBuilder),
        )._builder,
      settings: settings
    );

  };

}
```