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
- BindPageBuilder => [Widget], usado para acoplar uma instância de um [Object] para um outro [Widget] (página) filho usar como uma dependência (uma cotroller)
- UnKnowRouteBuilder => [Widget], usado para exibir uma página quando uma rota nomeda não existir
- ScreenRouteBuilder => [PageRoute], objeto criado para navegar para uma página usando uma [WidgetBuilder]


<br />
<br />


### Formas de navegar para um página

```dart
// Usando o navigator padrão do flutter
Navigator.of(context).pushNamed(
    RouteName.anyPage, 
    arguments: 'data'
);


// Sem o contexto usando o navigator da página ativa
RouteManager.currentNavigator?.pushNamed(
    RouteName.anyPage, 
    arguments: 'data'
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

### Exemplo de uso simple

```dart

// Para ver o exemplo de uso organizado por pasta e arquivos 
// acesse o projeto de exemplo dentro da package

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
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1'),
      ),
      body: Center(
        child: ColoredBox(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          child: TextButton(
            onPressed: (){
              Navigator.of(context).pushNamed(
                RouteName.anyPage, 
                arguments: 'data'
              );
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
        title: const Text('Page2'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Text(context.getArgument<String>() ?? 'argumento não definido'),
      ),
    );
  }
}

abstract class RouteName{
  static const String homePage = "/";
  static const String anyPage = "/anyPage";
}

abstract class AppRoutes {

  static RouteFactory get onGenerateRoute => (RouteSettings settings) {

    WidgetBuilder builder; 
    
    if (settings.name == RouteName.homePage) {

      builder = (_) => const HomePage();

    } else if (settings.name == RouteName.anyPage) {

      builder = (_) => const AnyPage();

    } else {
      builder = RouteManager.onUnKnowRouteBuilder;
    }
    
    // ======== Formas de definir o tipo de transição padrão da app ========

    // return CupertinoPageRoute(
    // return MaterialPageRoute(
    //   builder: builder,
    //   settings: settings
    // );

    // return PageRouteTransition.flutterDefault(
    //   builder: builder,
    //   settings: settings
    // );

    return PageRouteTransition.customized(
      builder: builder,
      settings: settings
    );

  };

}
```