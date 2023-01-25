part of '../route_manager.dart';

/// Página para exibir quando a rota nomeada não for encontrada ou não existir
@immutable
class UnKnowRouteBuilder extends StatelessWidget {
  const UnKnowRouteBuilder({Key? key}) : super(key: key);

  final TextStyle style = const TextStyle(
    height: 2.3,
    color: Colors.yellow,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 25.0),
              child: Text(
                ModalRoute.of(context)?.settings.name ?? 'UnKnowRoute',
                style: style,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flip_to_back_rounded, //priority_high_sharp
                    color: style.color,
                    size: 150.0,
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: style.color,
                          size: 45.0,
                        ),
                      ),
                      Text(
                        'Rota nomeada enexistente',
                        style: style,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
