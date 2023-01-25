import 'package:flutter/material.dart';
// import './any_page.dart';
import '../app_routes.dart';

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
              
              // Usando o navigator padrão do flutter
              // Navigator.of(context).pushNamed(
              //   RouteName.anyPage.name, 
              //   arguments: 'data'
              // );
              
              // Sem o contexto usando o navigator da página ativa
              // RouteManager.currentNavigator?.pushNamed(
              //   RouteName.anyPage.name, 
              //   arguments: 'data'
              // );

              // Sem o contexto usando o navigator da página ativa
              // RouteManager.push(
              //   builder: (_) => const AnyPage(), 
              //   settings: const RouteSettings(name: 'Page2', arguments: 'argument')
              // );

              // Sem o contexto usando o navigator da página ativa
              // RouteManager.pushNamed(
              //   routeName: RouteName.anyPage.name,
              //   arguments: 'argument'
              // );

              RouteName.anyPage.push();

              // Persolanizando uma animação para transição de uma página
              // //Navigator.of(context).push(
              // context.navigator.push(
              //   PageRouteTransition.customized(
              //     builder: (_) => const AnyPage(),
              //     transitionDuration: const Duration(milliseconds: 400),
              //     transitionType: TransitionType.fade
              //   )
              // );

              // Como essa função é possível escolher a transição 
              // [MaterialPageRoute] ou [CupertinoPageRoute]
              // context.navigator.push(
              //   PageRouteTransition.flutterDefault(
              //     builder: (_) => const AnyPage(),
              //   )
              // );

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
