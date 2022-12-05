import 'package:flutter/material.dart';

import '../app_routes.dart';

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
