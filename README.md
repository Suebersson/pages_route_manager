### Propriedades adicionadas dentro da BuildContext

- mediaQuery
- mediaQuerySize
- platform
- navigator
- modalRoute
- getArgument
- focusScopeNode

<br />
<br />


### Componentes e Objetos
- RouteManager => Tem os métodos e atributos necessários para gerenciar as rotas 
- ScreenRouteBuilder => [PageRoute], objeto criado para navegar para uma página usando uma [WidgetBuilder]
- RouteObserverProvider => [RouteObserver], Modelo para criar um objeto
- PageRouteTransition => Funções que retornam um objeto [Rote] para navegar entre páginas[Widget]
- TransitionType => Contém todos os tipos de animações para transição de rotas e suas variações
- PlatformPageTransitionsBuilder => Objeto facilitador para definir a animação de transição de rotas no tema da app
- RouteNavigator => Contém funções abstratas do objeto[Navigator] para navegação de rotas
- CreatePageRoute => Usado para criar rotas de página

<br />
<br />


### Widgets
- BindPageBuilder => usado para acoplar uma instância de um [Object] para um outro [Widget] (página) filho usar como uma dependência (uma cotroller)
- UnKnowRouteBuilder => usado para exibir uma página quando uma rota nomeda não existir
- StatelessArgument => criar uma página e carregar o argumento já convertido(cast)
- WidgetTransitionAnimation ==> widgtes que contém todas as animações de transição de rotas

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
RouteNavigator.push(
  builder: (_) => const AnyPage(), 
  settings: const RouteSettings(name: 'Page2', arguments: 'argument')
);

// Sem o contexto usando o navigator da página ativa
RouteName.anyPage.push();

// Sem o contexto usando o navigator da página ativa
RouteNavigator.pushNamed(
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

import 'package:flutter/cupertino.dart';
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
      onGenerateRoute: CreatePageRoute.onGenerateRoute,
      onUnknownRoute: RouteManager.onUnknownRoute,
    ),
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
              RouteName.anyPage.push();
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

  static final CreatePageRoute homePage = CreatePageRoute('/', (_) => const HomePage());

  static final CreatePageRoute anyPage = CreatePageRoute('/anyPage', (_) => const AnyPage());

}
```